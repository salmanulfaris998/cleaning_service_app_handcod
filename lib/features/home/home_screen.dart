import 'package:flutter/material.dart';
import 'package:hancod_machine_test/features/home/widgets/cart_button.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/location_select_bar.dart';
import '../../core/widgets/search_bar_field.dart';
import 'widgets/service_banner_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: LocationSelectBar(
                  location: '406, Skyline Park Dale, MM Road',
                  onLocationTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              CartButton(cartCount: 2, onTap: () {}),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: ServiceBannerCarousel(),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: SearchBarField(),
        ),
        const SizedBox(height: AppSpacing.xl),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
