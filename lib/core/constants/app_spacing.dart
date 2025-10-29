import 'package:flutter/widgets.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  static const SizedBox xsGap = SizedBox(height: xs, width: xs);
  static const SizedBox smGap = SizedBox(height: sm, width: sm);
  static const SizedBox mdGap = SizedBox(height: md, width: md);
  static const SizedBox lgGap = SizedBox(height: lg, width: lg);
  static const SizedBox xlGap = SizedBox(height: xl, width: xl);
  static const SizedBox xxlGap = SizedBox(height: xxl, width: xxl);
  static const SizedBox xxxlGap = SizedBox(height: xxxl, width: xxxl);
}
