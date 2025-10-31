import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cart_model.dart';
import '../data/service/cart_service.dart';

class CartController extends StateNotifier<CartState> {
  final CartService _cartService;
  
  CartController(this._cartService) : super(const CartState());

  static const double walletBalance = 1250.0;
  static const double serviceFeeFlat = 49.0;

  void addItem(CartItem item) {
    final existingIndex =
        state.items.indexWhere((cartItem) => cartItem.id == item.id);
    if (existingIndex >= 0) {
      _updateItem(
        existingIndex,
        state.items[existingIndex]
            .copyWith(quantity: state.items[existingIndex].quantity + 1),
      );
    } else {
      state = state.copyWith(items: [...state.items, item]);
    }
    
    // Sync to Supabase
    _syncToSupabase(item.id, item.quantity);
  }
  
  /// Load cart from Supabase
  Future<void> loadCartFromSupabase() async {
    try {
      final items = await _cartService.getCartItems();
      state = CartState(items: items);
      print('✅ Cart loaded from Supabase: ${items.length} items');
    } catch (e) {
      print('❌ Error loading cart from Supabase: $e');
    }
  }

  void incrementItem(String id) {
    final idx = state.items.indexWhere((item) => item.id == id);
    if (idx >= 0) {
      final current = state.items[idx];
      final newQuantity = current.quantity + 1;
      _updateItem(idx, current.copyWith(quantity: newQuantity));
      
      // Sync to Supabase
      _syncToSupabase(id, newQuantity);
    }
  }

  void decrementItem(String id) {
    final idx = state.items.indexWhere((item) => item.id == id);
    if (idx >= 0) {
      final current = state.items[idx];
      if (current.quantity > 1) {
        final newQuantity = current.quantity - 1;
        _updateItem(idx, current.copyWith(quantity: newQuantity));
        
        // Sync to Supabase
        _syncToSupabase(id, newQuantity);
      } else {
        removeItem(id);
      }
    }
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );
    
    // Remove from Supabase
    _cartService.removeFromCart(id).catchError((e) {
      print('❌ Error removing from Supabase: $e');
    });
  }

  void clearCart() {
    state = const CartState();
    
    // Clear from Supabase
    _cartService.clearCart().catchError((e) {
      print('❌ Error clearing Supabase cart: $e');
    });
  }

  void setQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    final idx = state.items.indexWhere((item) => item.id == id);
    if (idx >= 0) {
      _updateItem(idx, state.items[idx].copyWith(quantity: quantity));
      
      // Sync to Supabase
      _syncToSupabase(id, quantity);
    }
  }
  
  /// Sync cart item to Supabase
  void _syncToSupabase(String serviceId, int quantity) {
    _cartService.updateQuantity(serviceId, quantity).catchError((e) {
      print('❌ Error syncing to Supabase: $e');
    });
  }

  void _updateItem(int index, CartItem updated) {
    final updatedItems = [...state.items];
    updatedItems[index] = updated;
    state = state.copyWith(items: updatedItems);
  }
}

final cartControllerProvider =
    StateNotifierProvider<CartController, CartState>((ref) {
  final cartService = ref.read(cartServiceProvider);
  return CartController(cartService);
});

/// Provider for CartService
final cartServiceProvider = Provider<CartService>((ref) {
  return CartService();
});

final cartProvider = cartControllerProvider;

final cartSummaryProvider = Provider<CartSummary>((ref) {
  final state = ref.watch(cartControllerProvider);
  final subtotal = state.subtotal;
  final redeemableAmount = state.isEmpty
      ? 0.0
      : math.min(CartController.walletBalance, subtotal * 0.2);
  final serviceFee = state.isEmpty ? 0.0 : CartController.serviceFeeFlat;

  return CartSummary(
    state: state,
    walletBalance: CartController.walletBalance,
    redeemableAmount: redeemableAmount,
    serviceFee: serviceFee,
  );
});
