import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_machine_test/features/auth/presentation/widgets/otp_fields.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../controllers/phone_auth_controller.dart';

class PhoneOtpScreen extends ConsumerWidget {
  const PhoneOtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneState = ref.watch(phoneAuthControllerProvider);
    final phoneNotifier = ref.read(phoneAuthControllerProvider.notifier);
    final phoneController = ref.watch(phoneTextControllerProvider);
    final otpControllers = ref.watch(otpTextControllersProvider);
    final otpFocusNodes = ref.watch(otpFocusNodesProvider);

    for (var i = 0; i < otpControllers.length; i++) {
      final value = phoneState.otpDigits[i];
      final controller = otpControllers[i];
      if (controller.text != value) {
        controller
          ..text = value
          ..selection = TextSelection.collapsed(offset: value.length);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: GoRouter.of(context).pop,
        ),
        title: const Text('Phone Verification', style: AppTextStyles.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your phone number',
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: 8),
              const Text(
                'We will send you a one-time password (OTP) to verify your number.',
                style: AppTextStyles.bodyLight,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CountryCode>(
                        value: phoneState.selectedCode,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: AppTextStyles.body,
                        onChanged: (value) {
                          if (value == null) return;
                          phoneNotifier.selectCountry(value);
                        },
                        items: phoneCountryCodes
                            .map(
                              (code) => DropdownMenuItem<CountryCode>(
                                value: code,
                                child: Text('${code.flag} ${code.dialCode}'),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone number',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              if (phoneState.otpRequested) ...[
                const SizedBox(height: 24),
                const Text('Enter your OTP', style: AppTextStyles.heading2),
                const SizedBox(height: 12),
                OtpFields(
                  controllers: otpControllers,
                  focusNodes: otpFocusNodes,
                  onChanged: (index, value) {
                    final sanitized = value.isNotEmpty
                        ? value.substring(value.length - 1)
                        : '';
                    phoneNotifier.updateOtpDigit(index, sanitized);
                    if (sanitized.isNotEmpty &&
                        index < otpFocusNodes.length - 1) {
                      otpFocusNodes[index + 1].requestFocus();
                    } else if (sanitized.isEmpty && index > 0) {
                      otpFocusNodes[index - 1].requestFocus();
                    }
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      phoneNotifier.resendOtp();
                      for (final controller in otpControllers) {
                        controller.clear();
                      }
                      otpFocusNodes.first.requestFocus();
                    },
                    child: const Text('Resend OTP'),
                  ),
                ),
              ],
              const Spacer(),
              CustomButton(
                label: phoneState.otpRequested ? 'Login' : 'Get OTP',
                backgroundColor: AppColors.primary,
                textStyle: AppTextStyles.button,
                onPressed: () {
                  if (!phoneState.otpRequested) {
                    phoneNotifier.requestOtp();
                    for (final controller in otpControllers) {
                      controller.clear();
                    }
                    otpFocusNodes.first.requestFocus();
                  } else {
                    // TODO: Validate OTP and continue login.
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
