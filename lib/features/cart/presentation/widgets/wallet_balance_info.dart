import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

class WalletBalanceInfo extends StatelessWidget {
  const WalletBalanceInfo({
    super.key,
    required this.walletBalance,
    required this.redeemableAmount,
  });

  final double walletBalance;
  final double redeemableAmount;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 33,
          width: 33,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF6CCB73), Color(0xFF3A9960)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'Your wallet balance is '),
                TextSpan(
                  text: '₹${walletBalance.toStringAsFixed(0)}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(text: ', you can redeem '),
                TextSpan(
                  text: '₹${redeemableAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(text: ' in this order.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
