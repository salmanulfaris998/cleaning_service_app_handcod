import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_texts.dart';

class CleaningService {
  final String name;
  final String imagePath;

  const CleaningService({required this.name, required this.imagePath});
}

class CleaningServicesSection extends StatelessWidget {
  const CleaningServicesSection({
    super.key,
    required this.services,
    required this.onSeeAll,
  });

  final List<CleaningService> services;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppTexts.cleaningServicesTitle,
                style: AppTextStyles.heading2,
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Row(
                  children: [
                    Text(AppTexts.seeAll, style: AppTextStyles.greenHighlight),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == services.length - 1 ? 0 : AppSpacing.lg,
                ),
                child: _CleaningServiceCard(service: service),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CleaningServiceCard extends StatelessWidget {
  const _CleaningServiceCard({required this.service});

  final CleaningService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.cardBackground,
                ),
                child: Image.asset(service.imagePath, fit: BoxFit.cover),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              color: AppColors.cardBackground,
              child: Text(
                service.name,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
