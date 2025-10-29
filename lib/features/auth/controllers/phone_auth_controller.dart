import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PhoneAuthState {
  const PhoneAuthState({
    required this.selectedCode,
    required this.otpRequested,
    required this.otpDigits,
  });

  final CountryCode selectedCode;
  final bool otpRequested;
  final List<String> otpDigits;

  factory PhoneAuthState.initial() => PhoneAuthState(
        selectedCode: phoneCountryCodes.first,
        otpRequested: false,
        otpDigits: _emptyDigits(),
      );

  PhoneAuthState copyWith({
    CountryCode? selectedCode,
    bool? otpRequested,
    List<String>? otpDigits,
  }) {
    return PhoneAuthState(
      selectedCode: selectedCode ?? this.selectedCode,
      otpRequested: otpRequested ?? this.otpRequested,
      otpDigits: otpDigits ?? this.otpDigits,
    );
  }
}

class PhoneAuthController extends StateNotifier<PhoneAuthState> {
  PhoneAuthController() : super(PhoneAuthState.initial());

  void selectCountry(CountryCode code) {
    state = state.copyWith(selectedCode: code);
  }

  void requestOtp() {
    state = state.copyWith(
      otpRequested: true,
      otpDigits: _emptyDigits(),
    );
  }

  void resendOtp() {
    state = state.copyWith(
      otpDigits: _emptyDigits(),
      otpRequested: true,
    );
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
}

final phoneAuthControllerProvider =
    StateNotifierProvider<PhoneAuthController, PhoneAuthState>(
  (ref) => PhoneAuthController(),
);

List<String> _emptyDigits() => List<String>.filled(4, '');

final phoneTextControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final otpTextControllersProvider =
    Provider.autoDispose<List<TextEditingController>>((ref) {
  final controllers = List.generate(4, (_) => TextEditingController());
  ref.onDispose(() {
    for (final controller in controllers) {
      controller.dispose();
    }
  });
  return controllers;
});

final otpFocusNodesProvider = Provider.autoDispose<List<FocusNode>>((ref) {
  final focusNodes = List.generate(4, (_) => FocusNode());
  ref.onDispose(() {
    for (final node in focusNodes) {
      node.dispose();
    }
  });
  return focusNodes;
});
