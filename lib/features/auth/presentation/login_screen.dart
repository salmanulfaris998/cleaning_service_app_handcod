import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/safe_page_wrapper.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import 'widgets/logo_placeholder.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    // Navigate to home if authenticated
    ref.listen(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
      }
    });

    return SafePageWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                LogoPlaceholder(),

                const SizedBox(height: 140),

                // Show error message if any
                if (authState.status == AuthStatus.error) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authState.errorMessage ?? 'An error occurred',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: authController.clearError,
                          icon: Icon(
                            Icons.close,
                            color: Colors.red.shade600,
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ],

                CustomButton(
                  label: AppTexts.loginContinueWithGoogle,
                  backgroundColor: Colors.grey.shade300,
                  borderColor: AppColors.border,
                  textStyle: AppTextStyles.buttonDark,
                  icon: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Image.asset(
                          AppImages.googleIcon,
                          height: 24,
                          width: 24,
                        ),
                  onPressed: authState.status == AuthStatus.loading
                      ? () {}
                      : () => authController.signInWithGoogle(),
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: AppTexts.loginContinueWithPhone,
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.button,
                  onPressed: authState.status == AuthStatus.loading
                      ? () {}
                      : () => context.push(AppRoutes.phoneAuth),
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
