import 'package:flutter/material.dart';

import '../../core/constants/app_text_styles.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('My Account', style: AppTextStyles.heading1),
          SizedBox(height: 12),
          Text(
            'Manage your personal details and preferences here.',
            style: AppTextStyles.bodyLight,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
