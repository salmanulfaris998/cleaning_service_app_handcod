import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/cart_model.dart';

class CartController extends StateNotifier<CartState> {
  CartController() : super(const CartState());

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
  }

  void incrementItem(String id) {
    final idx = state.items.indexWhere((item) => item.id == id);
    if (idx >= 0) {
      final current = state.items[idx];
      _updateItem(idx, current.copyWith(quantity: current.quantity + 1));
    }
  }

  void decrementItem(String id) {
    final idx = state.items.indexWhere((item) => item.id == id);
    if (idx >= 0) {
      final current = state.items[idx];
      if (current.quantity > 1) {
        _updateItem(idx, current.copyWith(quantity: current.quantity - 1));
      } else {
        removeItem(id);
      }
    }
  }

  void removeItem(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(),
    );
  }

  void clearCart() {
    state = const CartState();
  }

  void setQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    final idx = state.items.indexWhere((item) => item.id == id);
    if (idx >= 0) {
      _updateItem(idx, state.items[idx].copyWith(quantity: quantity));
    }
  }

  void _updateItem(int index, CartItem updated) {
    final updatedItems = [...state.items];
    updatedItems[index] = updated;
    state = state.copyWith(items: updatedItems);
  }
}

final cartControllerProvider =
    StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
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
