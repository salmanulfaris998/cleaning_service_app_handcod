import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_texts.dart';

final navIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key, required this.child});

  final Widget child;

  static const List<String> _tabs = ['/home', '/bookings', '/account'];
  static const List<String> _titles = ['Home', 'Bookings', 'Account'];

  int _indexForLocation(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i] || location.startsWith(_tabs[i])) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(location);
    final navController = ref.read(navIndexProvider.notifier);
    if (navController.state != currentIndex) {
      navController.state = currentIndex;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_titles[currentIndex], style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: child,
      bottomNavigationBar: const _CustomBottomNavBar(),
    );
  }
}

class _CustomBottomNavBar extends ConsumerWidget {
  const _CustomBottomNavBar();

  static const List<String> _labels = [
    AppTexts.navHome,
    AppTexts.navBookings,
    AppTexts.navAccount,
  ];

  static const List<String> _routes = ['/home', '/bookings', '/account'];

  static const List<String> _iconPaths = [
    AppImages.navHome,
    AppImages.navBooking,
    AppImages.navAccount,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_iconPaths.length, (index) {
          final bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              if (selectedIndex != index) {
                ref.read(navIndexProvider.notifier).state = index;
                context.go(_routes[index]);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Row(
                children: [
                  if (isSelected)
                    Image.asset(
                      _iconPaths[index],
                      height: index == 0 ? 40 : 24,
                      width: index == 0 ? 40 : 24,
                    )
                  else
                    ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        AppColors.textHint,
                        BlendMode.srcIn,
                      ),
                      child: Image.asset(
                        _iconPaths[index],
                        height: index == 0 ? 32 : 24,
                        width: index == 0 ? 32 : 24,
                      ),
                    ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(_labels[index], style: AppTextStyles.buttonDark),
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
