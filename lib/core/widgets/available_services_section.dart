import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_texts.dart';

class AvailableService {
  final String name;
  final String iconPath;

  const AvailableService({required this.name, required this.iconPath});
}

class AvailableServicesSection extends StatelessWidget {
  const AvailableServicesSection({
    super.key,
    required this.services,
    required this.onSeeAll,
  });

  final List<AvailableService> services;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppTexts.availableServicesTitle, style: AppTextStyles.heading2),
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: services.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: AppSpacing.lg,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.6,
            ),
            itemBuilder: (context, index) {
              final isSeeAll = index == services.length;
              if (isSeeAll) {
                return _SeeAllTile(onTap: onSeeAll);
              }

              final service = services[index];
              return _ServiceTile(service: service);
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({required this.service});

  final AvailableService service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xs + 2),
            child: Image.asset(service.iconPath, fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          service.name,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _SeeAllTile extends StatelessWidget {
  const _SeeAllTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Image.asset(AppImages.seeAllServices, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(AppTexts.seeAll, style: AppTextStyles.greenHighlight),
        ],
      ),
    );
  }
}
