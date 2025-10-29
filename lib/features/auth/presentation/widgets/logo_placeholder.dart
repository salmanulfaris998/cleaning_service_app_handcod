import 'package:flutter/material.dart';
import 'package:hancod_machine_test/core/constants/app_images.dart';

class LogoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 240,

      alignment: Alignment.center,
      child: Image.asset(
        AppImages.appLogo,
        fit: BoxFit.contain,
        height: 180,
      ),
    );
  }
}
