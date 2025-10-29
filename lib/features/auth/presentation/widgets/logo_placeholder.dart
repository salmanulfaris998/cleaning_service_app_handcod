import 'package:flutter/material.dart';
import 'package:hancod_machine_test/core/constants/app_colors.dart';

class LogoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 240,

      alignment: Alignment.center,
      child: Image.asset(
        'asset/logos/app_logo.png',
        fit: BoxFit.contain,
        height: 180,
      ),
    );
  }
}
