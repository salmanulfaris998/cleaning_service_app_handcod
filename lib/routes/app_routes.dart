import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}
