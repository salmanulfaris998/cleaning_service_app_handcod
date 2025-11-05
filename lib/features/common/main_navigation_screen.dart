import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/safe_page_wrapper.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_texts.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafePageWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // StatefulNavigationShell automatically preserves state
            navigationShell,

            // Custom Bottom Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _CustomBottomNavBar(
                selectedIndex: navigationShell.currentIndex,
                onTabSelected: _onTabSelected,
                labels: const [
                  AppTexts.navHome,
                  AppTexts.navBookings,
                  AppTexts.navAccount,
                ],
                iconPaths: const [
                  AppImages.navHome,
                  AppImages.navBooking,
                  AppImages.navAccount,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar({
    required this.selectedIndex,
    required this.onTabSelected,
    required this.labels,
    required this.iconPaths,
  });

  final int selectedIndex;
  final Function(int) onTabSelected;
  final List<String> labels;
  final List<String> iconPaths;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(iconPaths.length, (index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  Image.asset(
                    iconPaths[index],
                    height: index == 0 ? 28 : 24,
                    width: index == 0 ? 28 : 24,
                    color: isSelected ? null : AppColors.textHint,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      labels[index],
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
