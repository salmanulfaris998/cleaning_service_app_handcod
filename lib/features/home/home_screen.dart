import 'package:flutter/material.dart';
import 'package:hancod_machine_test/features/home/widgets/cart_button.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/location_select_bar.dart';
import 'widgets/service_banner_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: LocationSelectBar(
                  location: '406, Skyline Park Dale, MM Road',
                  onLocationTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              CartButton(cartCount: 2, onTap: () {}),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: ServiceBannerCarousel(),
        ),
        const SizedBox(height: 24),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
