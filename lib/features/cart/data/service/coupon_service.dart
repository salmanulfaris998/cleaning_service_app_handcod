import 'package:supabase_flutter/supabase_flutter.dart' as supabase_lib;

final supabase = supabase_lib.Supabase.instance.client;

class CouponService {
  /// Validate a coupon code
  Future<Map<String, dynamic>?> validateCoupon(String code) async {
    try {
      // Sanitize input: trim whitespace and convert to uppercase
      final sanitizedCode = code.trim().toUpperCase();

      if (sanitizedCode.isEmpty) {
        print('❌ Coupon code is empty');
        return null;
      }

      print('🔍 Validating coupon: $sanitizedCode');

      final now = DateTime.now().toUtc();

      final result = await supabase
          .from('coupons')
          .select()
          .eq('code', sanitizedCode)
          .eq('active', true)
          .lte('valid_from', now.toIso8601String())
          .gte('valid_until', now.toIso8601String())
          .maybeSingle();

      if (result == null) {
        print('❌ Coupon "$sanitizedCode" not found or expired');
        return null;
      }

      // Check max uses
      final usedCount = result['used_count'] as int? ?? 0;
      final maxUses = result['max_uses'] as int? ?? 0;

      if (usedCount >= maxUses) {
        print(
          '❌ Coupon "$sanitizedCode" usage limit reached ($usedCount/$maxUses)',
        );
        return null;
      }

      print(
        'Coupon validated: ${result['code']} - ${result['discount_percent']}% discount',
      );
      return result;
    } catch (e) {
      print('❌ Error validating coupon: $e');
      return null;
    }
  }

  /// Mark coupon as used (increment usage count)
  Future<void> markCouponUsed(String code) async {
    try {
      final sanitizedCode = code.trim().toUpperCase();
      await supabase.rpc(
        'increment_coupon_use',
        params: {'coupon_code': sanitizedCode},
      );
      print(' Coupon usage recorded: $sanitizedCode');
    } catch (e) {
      print('❌ Error marking coupon as used: $e');
      rethrow;
    }
  }

  /// Get coupon discount amount for a given subtotal
  double calculateDiscount(Map<String, dynamic> coupon, double subtotal) {
    final discountPercent = (coupon['discount_percent'] as num).toDouble();
    return subtotal * (discountPercent / 100);
  }
}

/// Global instance of CouponService
final couponService = CouponService();

/// Example function to apply a coupon
Future<Map<String, dynamic>?> applyCoupon(String code) async {
  final coupon = await couponService.validateCoupon(code);

  if (coupon == null) {
    print('❌ Invalid or expired coupon');
    return null;
  }

  final discountPercent = coupon['discount_percent'] as num;
  print('Coupon applied! Discount: $discountPercent%');

  return coupon;

  // Note: Call markCouponUsed after order is confirmed
  // await couponService.markCouponUsed(code);
}
