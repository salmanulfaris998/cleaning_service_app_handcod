import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final bool requireAuth;

  const AuthGuard({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // Show loading while checking auth state
    if (authState.status == AuthStatus.initial || authState.status == AuthStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If authentication is required but user is not authenticated
    if (requireAuth && authState.status != AuthStatus.authenticated) {
      // Navigate to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.login);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If authentication is not required but user is authenticated
    if (!requireAuth && authState.status == AuthStatus.authenticated) {
      // Navigate to home screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRoutes.home);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return child;
  }
}

// Convenience wrapper for protected routes
class ProtectedRoute extends ConsumerWidget {
  final Widget child;

  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthGuard(
      requireAuth: true,
      child: child,
    );
  }
}

// Convenience wrapper for public routes (redirect if authenticated)
class PublicRoute extends ConsumerWidget {
  final Widget child;

  const PublicRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AuthGuard(
      requireAuth: false,
      child: child,
    );
  }
}
