import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hancod_machine_test/core/constants/app_colors.dart';
import 'package:hancod_machine_test/core/constants/app_spacing.dart';
import 'package:hancod_machine_test/core/constants/app_text_styles.dart';
import 'package:hancod_machine_test/features/cart/presentation/widgets/quantity_button.dart';

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuantityButton(
          label: '- ',
          onTap: onDecrease,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          color: AppColors.neutral,
          alignment: Alignment.center,
          child: Text(
            '$quantity',
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        QuantityButton(
          label: '+',
          onTap: onIncrease,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      ],
    );
  }
}
