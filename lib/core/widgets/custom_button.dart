import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.label,
    required this.backgroundColor,
    required this.textStyle,
    this.borderColor,
    this.icon,
    this.trailingIcon,
    this.onPressed = _noop,
    super.key,
  });

  final String label;
  final Color backgroundColor;
  final Color? borderColor;
  final TextStyle textStyle;
  final Widget? icon;
  final Widget? trailingIcon;
  final VoidCallback onPressed;

  static void _noop() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Text(label, style: textStyle),
            if (trailingIcon != null) ...[
              const SizedBox(width: 12),
              trailingIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
