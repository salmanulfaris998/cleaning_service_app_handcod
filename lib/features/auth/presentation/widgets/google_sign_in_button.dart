import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../controllers/auth_controller.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    return CustomButton(
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
    );
  }
}
