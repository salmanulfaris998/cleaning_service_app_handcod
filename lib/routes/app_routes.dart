import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/safe_page_wrapper.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/phone_otp_screen.dart';
import '../features/bookings/bookings_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/common/main_navigation_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/my_account/my_account_screen.dart';
import '../features/cleaning_services/presentation/service_listing_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String home = '/home';
  static const String bookings = '/bookings';
  static const String account = '/account';
  static const String phoneAuth = '/auth/phone';
  static const String services = '/services';
  static const String cart = '/cart';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) => _fadeTransition(
          const SafePageWrapper(child: LoginScreen()),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: phoneAuth,
        name: 'phoneAuth',
        pageBuilder: (context, state) => _fadeTransition(
          const SafePageWrapper(child: PhoneOtpScreen()),
          key: state.pageKey,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            pageBuilder: (context, state) => _fadeTransition(
              const SafePageWrapper(child: HomeScreen()),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: bookings,
            name: 'bookings',
            pageBuilder: (context, state) => _fadeTransition(
              const SafePageWrapper(child: BookingsScreen()),
              key: state.pageKey,
            ),
          ),
          GoRoute(
            path: account,
            name: 'account',
            pageBuilder: (context, state) => _fadeTransition(
              const SafePageWrapper(child: MyAccountScreen()),
              key: state.pageKey,
            ),
          ),
        ],
      ),
      GoRoute(
        path: services,
        name: 'services',
        pageBuilder: (context, state) => _fadeTransition(
          const SafePageWrapper(child: ServiceListingScreen()),
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        pageBuilder: (context, state) => _fadeTransition(
          const SafePageWrapper(child: CartScreen()),
          key: state.pageKey,
        ),
      ),
    ],
  );

  // 🔹 Fade Transition for all tab routes
  static CustomTransitionPage<void> _fadeTransition(
    Widget child, {
    LocalKey? key,
  }) {
    return CustomTransitionPage<void>(
      key: key ?? ValueKey(child.hashCode),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
