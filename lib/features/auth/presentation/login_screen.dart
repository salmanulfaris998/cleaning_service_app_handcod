import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import 'widgets/logo_placeholder.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              LogoPlaceholder(),

              const SizedBox(height: 140),
              CustomButton(
                label: 'Continue with Google',
                backgroundColor: Colors.grey.shade300,
                borderColor: AppColors.border,
                textStyle: AppTextStyles.buttonDark,
                icon: Image.asset(
                  'asset/icons/google.png',
                  height: 24,
                  width: 24,
                ),
                onPressed: () => context.push(AppRoutes.home),
              ),
              const SizedBox(height: 16),
              CustomButton(
                label: 'Phone',
                backgroundColor: AppColors.primary,
                textStyle: AppTextStyles.button,
                onPressed: () => context.push(AppRoutes.phoneAuth),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
