import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/phone_otp_screen.dart';
import '../features/bookings/bookings_screen.dart';
import '../features/common/main_navigation_screen.dart';
import '../features/home/home_screen.dart';
import '../features/my_account/my_account_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String home = '/home';
  static const String bookings = '/bookings';
  static const String account = '/account';
  static const String phoneAuth = '/auth/phone';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: phoneAuth,
        name: 'phoneAuth',
        builder: (context, state) => const PhoneOtpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: bookings,
            name: 'bookings',
            builder: (context, state) => const BookingsScreen(),
          ),
          GoRoute(
            path: account,
            name: 'account',
            builder: (context, state) => const MyAccountScreen(),
          ),
        ],
      ),
    ],
  );
}
