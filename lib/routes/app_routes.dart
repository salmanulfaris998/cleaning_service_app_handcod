import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/safe_page_wrapper.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/phone_otp_screen.dart';
import '../features/bookings/bookings_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/common/main_navigation_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/my_account/presentation/my_account_screen.dart';
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
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const SafePageWrapper(child: LoginScreen()),
        ),
      ),
      GoRoute(
        path: phoneAuth,
        name: 'phoneAuth',
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const SafePageWrapper(child: PhoneOtpScreen()),
        ),
      ),

      // ✅ Changed from ShellRoute to StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                name: 'home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SafePageWrapper(child: HomeScreen()),
                ),
              ),
            ],
          ),

          // Branch 1: Bookings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: bookings,
                name: 'bookings',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SafePageWrapper(child: BookingsScreen()),
                ),
              ),
            ],
          ),

          // Branch 2: Account
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: account,
                name: 'account',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SafePageWrapper(child: MyAccountScreen()),
                ),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: services,
        name: 'services',
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const SafePageWrapper(child: ServiceListingScreen()),
        ),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        pageBuilder: (context, state) => CupertinoPage(
          key: state.pageKey,
          child: const SafePageWrapper(child: CartScreen()),
        ),
      ),
    ],
  );
}
