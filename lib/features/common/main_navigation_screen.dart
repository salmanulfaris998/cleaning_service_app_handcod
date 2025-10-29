import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

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
        title: Text(
          _titles[currentIndex],
          style: AppTextStyles.heading2,
        ),
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

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.calendar_month_rounded,
    Icons.person_rounded,
  ];

  static const List<String> _labels = [
    'Home',
    'Bookings',
    'Account',
  ];

  static const List<String> _routes = [
    '/home',
    '/bookings',
    '/account',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navIndexProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFEFFAF4)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(
                        color: const Color(0xFF3B82F6),
                        width: 2,
                      )
                    : null,
              ),
              child: Row(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: isSelected
                            ? const [
                                Color(0xFF34D399),
                                Color(0xFF059669),
                              ]
                            : const [Colors.grey, Colors.grey],
                      ).createShader(bounds);
                    },
                    child: Icon(
                      _icons[index],
                      size: 28,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      _labels[index],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
