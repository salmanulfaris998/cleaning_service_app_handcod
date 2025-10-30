import 'package:flutter/material.dart';

class SafePageWrapper extends StatelessWidget {
  final Widget child;
  const SafePageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Simply return the child - CupertinoPage handles swipe-to-back automatically
    // No need for PopScope wrapper
    return child;
  }
}
