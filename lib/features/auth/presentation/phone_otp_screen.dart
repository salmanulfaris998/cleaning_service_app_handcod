import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_machine_test/features/auth/presentation/widgets/otp_fields.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_textfield.dart';
import '../../../core/widgets/safe_page_wrapper.dart';
import '../../../routes/app_routes.dart';
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

    // Listen for authentication success
    ref.listen(phoneAuthControllerProvider, (previous, next) {
      if (next.status == PhoneAuthStatus.verified) {
        context.go(AppRoutes.home);
      } else if (next.status == PhoneAuthStatus.error &&
          next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                phoneNotifier.clearError();
              },
            ),
          ),
        );
      }
    });

    for (var i = 0; i < otpControllers.length; i++) {
      final value = phoneState.otpDigits[i];
      final controller = otpControllers[i];
      if (controller.text != value) {
        controller
          ..text = value
          ..selection = TextSelection.collapsed(offset: value.length);
      }
    }

    return SafePageWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            AppTexts.phoneVerificationTitle,
            style: AppTextStyles.heading2,
          ),
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
                  AppTexts.phoneNumberPrompt,
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: 8),
                const Text(
                  AppTexts.phoneNumberSubtitle,
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
                        hintText: AppTexts.phoneNumberHint,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
                if (phoneState.otpRequested) ...[
                  const SizedBox(height: 24),
                  const Text(
                    AppTexts.enterOtpTitle,
                    style: AppTextStyles.heading2,
                  ),
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
                      onPressed: phoneState.isLoading
                          ? null
                          : () async {
                              await phoneNotifier.resendOtp();
                              for (final controller in otpControllers) {
                                controller.clear();
                              }
                              otpFocusNodes.first.requestFocus();
                            },
                      child: phoneState.isLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(AppTexts.resendOtp),
                    ),
                  ),
                ],
                const Spacer(),
                CustomButton(
                  label: phoneState.otpRequested
                      ? AppTexts.login
                      : AppTexts.getOtp,
                  backgroundColor: AppColors.primary,
                  textStyle: AppTextStyles.button,
                  onPressed: phoneState.isLoading
                      ? () {}
                      : () async {
                          if (!phoneState.otpRequested) {
                            final phoneNumber = phoneController.text.trim();
                            if (phoneNumber.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a phone number'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            await phoneNotifier.requestOtp(phoneNumber);
                            for (final controller in otpControllers) {
                              controller.clear();
                            }
                            otpFocusNodes.first.requestFocus();
                          } else {
                            await phoneNotifier.verifyOtp();
                          }
                        },
                  icon: phoneState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
