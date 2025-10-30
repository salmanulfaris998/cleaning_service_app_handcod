import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/phone_auth_service.dart';

class CountryCode {
  const CountryCode({required this.name, required this.dialCode});

  final String name;
  final String dialCode;

  String get flag {
    switch (dialCode) {
      case '+1':
        return '🇺🇸';
      case '+44':
        return '🇬🇧';
      case '+91':
        return '🇮🇳';
      case '+971':
        return '🇦🇪';
      default:
        return '🌐';
    }
  }
}

const List<CountryCode> phoneCountryCodes = [
  CountryCode(name: 'United States', dialCode: '+1'),
  CountryCode(name: 'United Kingdom', dialCode: '+44'),
  CountryCode(name: 'India', dialCode: '+91'),
  CountryCode(name: 'United Arab Emirates', dialCode: '+971'),
];

enum PhoneAuthStatus {
  initial,
  sendingOtp,
  otpSent,
  verifyingOtp,
  verified,
  error,
}

class PhoneAuthState {
  const PhoneAuthState({
    required this.selectedCode,
    required this.otpRequested,
    required this.otpDigits,
    required this.status,
    required this.verificationId,
    this.errorMessage,
    this.phoneNumber,
  });

  final CountryCode selectedCode;
  final bool otpRequested;
  final List<String> otpDigits;
  final PhoneAuthStatus status;
  final String verificationId;
  final String? errorMessage;
  final String? phoneNumber;

  factory PhoneAuthState.initial() => PhoneAuthState(
        selectedCode: phoneCountryCodes.first,
        otpRequested: false,
        otpDigits: _emptyDigits(),
        status: PhoneAuthStatus.initial,
        verificationId: '',
      );

  PhoneAuthState copyWith({
    CountryCode? selectedCode,
    bool? otpRequested,
    List<String>? otpDigits,
    PhoneAuthStatus? status,
    String? verificationId,
    String? errorMessage,
    String? phoneNumber,
  }) {
    return PhoneAuthState(
      selectedCode: selectedCode ?? this.selectedCode,
      otpRequested: otpRequested ?? this.otpRequested,
      otpDigits: otpDigits ?? this.otpDigits,
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage ?? this.errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  bool get isLoading => status == PhoneAuthStatus.sendingOtp || status == PhoneAuthStatus.verifyingOtp;
}

class PhoneAuthController extends StateNotifier<PhoneAuthState> {
  PhoneAuthController(this._phoneAuthService) : super(PhoneAuthState.initial());

  final PhoneAuthService _phoneAuthService;

  void selectCountry(CountryCode code) {
    state = state.copyWith(selectedCode: code);
  }

  Future<void> requestOtp(String phoneNumber) async {
    final fullPhoneNumber = '${state.selectedCode.dialCode}$phoneNumber';
    
    state = state.copyWith(
      status: PhoneAuthStatus.sendingOtp,
      phoneNumber: fullPhoneNumber,
      errorMessage: null,
    );

    try {
      await _phoneAuthService.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);
            state = state.copyWith(status: PhoneAuthStatus.verified);
          } catch (e) {
            state = state.copyWith(
              status: PhoneAuthStatus.error,
              errorMessage: 'Auto-verification failed: $e',
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          state = state.copyWith(
            status: PhoneAuthStatus.error,
            errorMessage: e.message ?? 'Verification failed',
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          state = state.copyWith(
            status: PhoneAuthStatus.otpSent,
            verificationId: verificationId,
            otpRequested: true,
            otpDigits: _emptyDigits(),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          state = state.copyWith(verificationId: verificationId);
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Failed to send OTP: $e',
      );
    }
  }

  Future<void> verifyOtp() async {
    final otpCode = state.otpDigits.join();
    if (otpCode.length != 6) {
      state = state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Please enter complete OTP',
      );
      return;
    }

    state = state.copyWith(
      status: PhoneAuthStatus.verifyingOtp,
      errorMessage: null,
    );

    try {
      await _phoneAuthService.verifyOTP(
        verificationId: state.verificationId,
        smsCode: otpCode,
      );
      
      state = state.copyWith(status: PhoneAuthStatus.verified);
    } catch (e) {
      state = state.copyWith(
        status: PhoneAuthStatus.error,
        errorMessage: 'Invalid OTP. Please try again.',
      );
    }
  }

  Future<void> resendOtp() async {
    if (state.phoneNumber != null) {
      state = state.copyWith(
        otpDigits: _emptyDigits(),
        errorMessage: null,
      );
      
      // Extract phone number without country code for resend
      final phoneWithoutCode = state.phoneNumber!.replaceFirst(state.selectedCode.dialCode, '');
      await requestOtp(phoneWithoutCode);
    }
  }

  void updateOtpDigit(int index, String value) {
    final nextDigits = List<String>.from(state.otpDigits);
    if (index >= 0 && index < nextDigits.length) {
      nextDigits[index] = value;
      state = state.copyWith(otpDigits: nextDigits);
    }
  }

  void clearOtpDigits() {
    state = state.copyWith(otpDigits: _emptyDigits());
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider for PhoneAuthService
final phoneAuthServiceProvider = Provider<PhoneAuthService>((ref) {
  return PhoneAuthService();
});

final phoneAuthControllerProvider =
    StateNotifierProvider<PhoneAuthController, PhoneAuthState>(
  (ref) => PhoneAuthController(ref.read(phoneAuthServiceProvider)),
);

List<String> _emptyDigits() => List<String>.filled(6, '');

final phoneTextControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final otpTextControllersProvider =
    Provider.autoDispose<List<TextEditingController>>((ref) {
  final controllers = List.generate(6, (_) => TextEditingController());
  ref.onDispose(() {
    for (final controller in controllers) {
      controller.dispose();
    }
  });
  return controllers;
});

final otpFocusNodesProvider = Provider.autoDispose<List<FocusNode>>((ref) {
  final focusNodes = List.generate(6, (_) => FocusNode());
  ref.onDispose(() {
    for (final node in focusNodes) {
      node.dispose();
    }
  });
  return focusNodes;
});
