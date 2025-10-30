import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({
    super.key,
    required this.totalLabel,
    required this.totalAmount,
    required this.buttonLabel,
    required this.onPressed,
    this.subtitle,
    this.buttonColor,
    this.buttonGradient,
  });

  final String totalLabel;
  final double totalAmount;
  final String buttonLabel;
  final VoidCallback onPressed;
  final String? subtitle;
  final Color? buttonColor;
  final Gradient? buttonGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
            '$totalLabel  |  ₹${totalAmount.toStringAsFixed(0)}',
            textAlign: TextAlign.center,
            style: AppTextStyles.heading2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _SummaryButton(
            label: buttonLabel,
            onPressed: onPressed,
            buttonColor: buttonColor,
            buttonGradient: buttonGradient,
          ),
        ],
      ),
    );
  }
}

class _SummaryButton extends StatelessWidget {
  const _SummaryButton({
    required this.label,
    required this.onPressed,
    this.buttonColor,
    this.buttonGradient,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? buttonColor;
  final Gradient? buttonGradient;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20);
    final gradient =
        buttonGradient ??
        (buttonColor == null
            ? const LinearGradient(
                colors: [Color(0xFF6CCB73), Color(0xFF188B5A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null);
    final color = gradient == null ? (buttonColor ?? AppColors.cta) : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            color: color,
            borderRadius: borderRadius,
          ),
          child: SizedBox(
            height: 56,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.button.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.chevron_right, size: 22, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
