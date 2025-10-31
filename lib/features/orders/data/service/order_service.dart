import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_lib;

import '../../../cart/data/service/coupon_service.dart';

final _supabase = supabase_lib.Supabase.instance.client;
final _firebaseAuth = FirebaseAuth.instance;

class OrderService {
  const OrderService();

  Future<String> _getSupabaseUserId() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw StateError('User not logged in');
    }

    final userData = await _supabase
        .from('users')
        .select('id')
        .eq('firebase_uid', firebaseUser.uid)
        .maybeSingle();

    if (userData == null || userData['id'] == null) {
      throw StateError('User not found in Supabase');
    }

    return userData['id'] as String;
  }

  /// Creates an order with current cart items and clears the cart afterwards.
  Future<bool> createOrder({
    required double subtotal,
    required double couponDiscount,
    double walletUsed = 0.0,
    required double tax,
    required double total,
    String? couponCode,
  }) async {
    try {
      final userId = await _getSupabaseUserId();

      // Fetch cart items along with price from services table
      final cartItemsResponse = await _supabase
          .from('cart')
          .select('service_id, quantity, services(price)')
          .eq('user_id', userId);

      final cartItems = List<Map<String, dynamic>>.from(cartItemsResponse);

      if (cartItems.isEmpty) {
        throw StateError('Cart is empty');
      }

      final totalDiscount = couponDiscount + walletUsed;

      final orderInsert = {
        'user_id': userId,
        'subtotal': subtotal,
        'discount': totalDiscount,
        'coupon_discount': couponDiscount,
        'wallet_used': walletUsed,
        'tax': tax,
        'total': total,
        'coupon_code': couponCode,
      }..removeWhere((key, value) => value == null);

      final orderResponse = await _supabase
          .from('orders')
          .insert(orderInsert)
          .select()
          .single();

      final orderId = orderResponse['id'] as String;

      // Insert order items
      final orderItemsPayload = cartItems.map((item) {
        final servicesData = item['services'] as Map<String, dynamic>;
        final price = (servicesData['price'] as num).toDouble();

        return {
          'order_id': orderId,
          'service_id': item['service_id'],
          'quantity': item['quantity'],
          'price': price,
        };
      }).toList();

      if (orderItemsPayload.isNotEmpty) {
        await _supabase.from('order_items').insert(orderItemsPayload);
      }

      // Clear cart in Supabase and local state
      await _supabase.from('cart').delete().eq('user_id', userId);

      // Increment coupon usage if applicable
      if (couponCode != null && couponCode.isNotEmpty) {
        await couponService.markCouponUsed(couponCode);
      }

      return true;
    } catch (e) {
      // Log the error for diagnostics
      // ignore: avoid_print
      print('❌ Failed to create order: $e');
      return false;
    }
  }
}

final orderService = OrderService();
