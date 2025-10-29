import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: HancodApp()));
}

class HancodApp extends StatelessWidget {
  const HancodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hancod Commerce',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: ThemeData.light().textTheme.copyWith(
          displayLarge: AppTextStyles.heading1,
          headlineMedium: AppTextStyles.heading2,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.bodyLight,
        ),
      ),
      routerDelegate: AppRoutes.router.routerDelegate,
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
    );
  }
}
