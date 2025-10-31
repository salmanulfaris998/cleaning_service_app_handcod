import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/coupon_service.dart';
import '../models/coupon_model.dart';

/// Provider for CouponService
final couponServiceProvider = Provider<CouponService>((ref) {
  return CouponService();
});

/// State provider for applied coupon
final appliedCouponProvider = StateProvider<CouponModel?>((ref) => null);

/// Provider to validate and apply a coupon
final validateCouponProvider = FutureProvider.family<CouponModel?, String>(
  (ref, code) async {
    final couponService = ref.read(couponServiceProvider);
    final result = await couponService.validateCoupon(code);
    
    if (result != null) {
      final coupon = CouponModel.fromJson(result);
      // Automatically set as applied coupon if valid
      ref.read(appliedCouponProvider.notifier).state = coupon;
      return coupon;
    }
    
    return null;
  },
);

/// Provider to calculate discount from applied coupon
final couponDiscountProvider = Provider.family<double, double>((ref, subtotal) {
  final appliedCoupon = ref.watch(appliedCouponProvider);
  
  if (appliedCoupon == null || !appliedCoupon.isValid) {
    return 0.0;
  }
  
  return appliedCoupon.calculateDiscount(subtotal);
});
