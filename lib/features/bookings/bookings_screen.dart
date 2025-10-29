import 'package:flutter/material.dart';

import '../../core/constants/app_text_styles.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Your Bookings', style: AppTextStyles.heading1),
          SizedBox(height: 12),
          Text(
            'Track and manage your service bookings here.',
            style: AppTextStyles.bodyLight,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
