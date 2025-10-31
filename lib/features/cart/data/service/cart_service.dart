import 'package:supabase_flutter/supabase_flutter.dart' as supabase_lib;
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_model.dart';

final supabase = supabase_lib.Supabase.instance.client;
final firebase = FirebaseAuth.instance;

class CartService {
  /// Get Supabase user ID from Firebase UID
  Future<String> _getSupabaseUserId() async {
    final firebaseUser = firebase.currentUser;
    if (firebaseUser == null) throw Exception('User not logged in');

    final userData = await supabase
        .from('users')
        .select('id')
        .eq('firebase_uid', firebaseUser.uid)
        .maybeSingle();

    if (userData == null) throw Exception('User not found in Supabase');

    return userData['id'];
  }

  /// Add item to cart or update quantity if exists
  Future<void> addToCart(String serviceId, int quantity) async {
    try {
      final userId = await _getSupabaseUserId();

      await supabase.from('cart').upsert(
        {
          'user_id': userId,
          'service_id': serviceId,
          'quantity': quantity,
        },
        onConflict: 'user_id,service_id',
      );

      print('✅ Added to cart: $serviceId (qty: $quantity)');
    } catch (e) {
      print('❌ Error adding to cart: $e');
      rethrow;
    }
  }

  /// Get all cart items with service details
  Future<List<CartItem>> getCartItems() async {
    try {
      final userId = await _getSupabaseUserId();

      final response = await supabase
          .from('cart')
          .select('*, services(*)')
          .eq('user_id', userId);

      // Convert response to CartItem list
      return (response as List).map((item) {
        final service = item['services'];
        return CartItem(
          id: service['id'],
          name: service['name'],
          price: (service['price'] as num).toDouble(),
          quantity: item['quantity'] as int,
        );
      }).toList();
    } catch (e) {
      print('❌ Error fetching cart items: $e');
      rethrow;
    }
  }

  /// Get raw cart data with full service details
  Future<List<Map<String, dynamic>>> getCartItemsRaw() async {
    try {
      final userId = await _getSupabaseUserId();

      final response = await supabase
          .from('cart')
          .select('*, services(*)')
          .eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching cart items: $e');
      rethrow;
    }
  }

  /// Update cart item quantity
  Future<void> updateQuantity(String serviceId, int quantity) async {
    try {
      final userId = await _getSupabaseUserId();

      if (quantity <= 0) {
        await removeFromCart(serviceId);
        return;
      }

      await supabase.from('cart').upsert(
        {
          'user_id': userId,
          'service_id': serviceId,
          'quantity': quantity,
        },
        onConflict: 'user_id,service_id',
      );

      print('✅ Updated cart quantity: $serviceId (qty: $quantity)');
    } catch (e) {
      print('❌ Error updating cart quantity: $e');
      rethrow;
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String serviceId) async {
    try {
      final userId = await _getSupabaseUserId();

      await supabase
          .from('cart')
          .delete()
          .eq('user_id', userId)
          .eq('service_id', serviceId);

      print('✅ Removed from cart: $serviceId');
    } catch (e) {
      print('❌ Error removing from cart: $e');
      rethrow;
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      final userId = await _getSupabaseUserId();

      await supabase.from('cart').delete().eq('user_id', userId);

      print('✅ Cart cleared');
    } catch (e) {
      print('❌ Error clearing cart: $e');
      rethrow;
    }
  }

  /// Sync local cart to Supabase (useful after login)
  Future<void> syncLocalCartToSupabase(List<CartItem> localItems) async {
    try {
      final userId = await _getSupabaseUserId();

      // Clear existing cart first
      await supabase.from('cart').delete().eq('user_id', userId);

      // Insert all local items
      if (localItems.isNotEmpty) {
        final cartData = localItems.map((item) => {
              'user_id': userId,
              'service_id': item.id,
              'quantity': item.quantity,
            }).toList();

        await supabase.from('cart').insert(cartData);
      }

      print('✅ Local cart synced to Supabase');
    } catch (e) {
      print('❌ Error syncing cart: $e');
      rethrow;
    }
  }
}
