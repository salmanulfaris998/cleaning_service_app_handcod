import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/cart_service.dart';
import '../models/cart_model.dart';

/// Provider for CartService
final cartServiceProvider = Provider<CartService>((ref) {
  return CartService();
});

/// Provider to fetch cart items from Supabase
final supabaseCartProvider = FutureProvider<List<CartItem>>((ref) async {
  final cartService = ref.read(cartServiceProvider);
  return await cartService.getCartItems();
});

/// Provider to fetch raw cart data with full service details
final supabaseCartRawProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final cartService = ref.read(cartServiceProvider);
  return await cartService.getCartItemsRaw();
});
