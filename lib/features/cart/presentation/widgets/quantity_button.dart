import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hancod_machine_test/core/constants/app_colors.dart';
import 'package:hancod_machine_test/core/constants/app_spacing.dart';
import 'package:hancod_machine_test/core/constants/app_text_styles.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    required this.label,
    required this.onTap,
    required this.borderRadius,
  });

  final String label;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textSecondary,
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
