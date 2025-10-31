import 'dart:developer' as developer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_lib;

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

    if (userData == null) throw StateError('User not found in Supabase');

    final id = userData['id'] as String?;
    if (id == null) {
      throw StateError('Supabase user record missing id');
    }

    return id;
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

      developer.log(
        'Added to cart: $serviceId (qty: $quantity)',
        name: 'CartService',
      );
    } catch (e, stackTrace) {
      developer.log(
        'Error adding to cart',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
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
      return (response as List<dynamic>).map((item) {
        final typedItem = item as Map<String, dynamic>;
        final service = typedItem['services'] as Map<String, dynamic>;
        return CartItem(
          id: service['id'] as String? ?? '',
          name: service['name'] as String? ?? '',
          price: (service['price'] as num?)?.toDouble() ?? 0,
          quantity: typedItem['quantity'] as int? ?? 0,
        );
      }).toList();
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching cart items',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
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

      return List<Map<String, dynamic>>.from(response as List<dynamic>);
    } catch (e, stackTrace) {
      developer.log(
        'Error fetching cart items raw',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
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
    } catch (e, stackTrace) {
      developer.log(
        'Error updating cart quantity',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
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
    } catch (e, stackTrace) {
      developer.log(
        'Error removing from cart',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
      rethrow;
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      final userId = await _getSupabaseUserId();

      await supabase.from('cart').delete().eq('user_id', userId);
    } catch (e, stackTrace) {
      developer.log(
        'Error clearing cart',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
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
    } catch (e, stackTrace) {
      developer.log(
        'Error syncing cart',
        error: e,
        stackTrace: stackTrace,
        name: 'CartService',
      );
      rethrow;
    }
  }
}
