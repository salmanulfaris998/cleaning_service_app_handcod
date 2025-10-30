import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.onViewCart,
  });

  final int totalItems;
  final double totalPrice;
  final VoidCallback onViewCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.4),
            blurRadius: 28,
            spreadRadius: 3,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$totalItems item${totalItems == 1 ? '' : 's'} | ₹${totalPrice.toStringAsFixed(0)}',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.sm),
          CustomButton(
            label: 'VIEW CART',
            backgroundColor: AppColors.cta,
            textStyle: AppTextStyles.button,
            trailingIcon: const Icon(
              Icons.chevron_right,
              size: 18,
              color: Colors.white,
            ),
            onPressed: onViewCart,
          ),
        ],
      ),
    );
  }
}
