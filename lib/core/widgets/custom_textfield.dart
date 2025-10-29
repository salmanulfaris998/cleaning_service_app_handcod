import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.controller,
    this.initialValue,
    this.hintText,
    this.keyboardType,
    this.prefix,
    this.onChanged,
    this.textInputAction,
    super.key,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyLight,
        prefixIcon: prefix,
        filled: true,
        fillColor: AppColors.cardBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      style: AppTextStyles.body,
    );
  }
}
