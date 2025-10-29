import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';

// Simple state provider for current page index
final currentPageProvider = StateProvider<int>((ref) => 0);

class ServiceBannerCarousel extends ConsumerStatefulWidget {
  const ServiceBannerCarousel({super.key});

  @override
  ConsumerState<ServiceBannerCarousel> createState() => _ServiceBannerCarouselState();
}

class _ServiceBannerCarouselState extends ConsumerState<ServiceBannerCarousel> {
  late final PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final currentPage = ref.read(currentPageProvider);
      final nextPage = (currentPage + 1) % AppImages.serviceBanners.length;
      ref.read(currentPageProvider.notifier).state = nextPage;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageProvider);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(currentPageProvider.notifier).state = index;
                },
                itemCount: AppImages.serviceBanners.length,
                itemBuilder: (context, index) {
                  final asset = AppImages.serviceBanners[index];
                  return Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(AppImages.serviceBanners.length, (index) {
            final isActive = index == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 16 : 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.textHint.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
