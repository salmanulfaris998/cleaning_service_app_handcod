import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_text_styles.dart';

class LocationSelectBar extends StatelessWidget {
  const LocationSelectBar({
    super.key,
    required this.location,
    this.onLocationTap,
  });

  final String location;
  final VoidCallback? onLocationTap;

  @override
  Widget build(BuildContext context) {
    final displayLocation = _formattedLocation(location);

    return GestureDetector(
      onTap: onLocationTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              displayLocation,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Image.asset(
              AppImages.downArrow,
              height: 18,
              width: 18,
            ),
          ),
        ],
      ),
    );
  }

  String _formattedLocation(String value) {
    final parts = value.split(',');
    if (parts.length <= 2) {
      return value.trim();
    }

    final first = parts.first.trim();
    final second = parts[1].trim();
    return '$first, $second...';
  }
}
