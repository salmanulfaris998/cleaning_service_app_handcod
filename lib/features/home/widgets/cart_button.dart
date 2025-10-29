import 'package:flutter/material.dart';
import 'package:hancod_machine_test/core/constants/app_colors.dart';
import 'package:hancod_machine_test/core/constants/app_images.dart';
import 'package:hancod_machine_test/core/constants/app_text_styles.dart';

class CartButton extends StatelessWidget {
  const CartButton({required this.cartCount, this.onTap});

  final int cartCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Image.asset(AppImages.navCart, height: 35, width: 35),
          ),
          if (cartCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBackground, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  cartCount.toString(),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.cardBackground,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
