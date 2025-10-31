import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'routes/app_routes.dart';

const supabaseUrl = 'https://frdxeonkhacpsztfmztd.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZyZHhlb25raGFjcHN6dGZtenRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NTIxNDksImV4cCI6MjA3NzQyODE0OX0.0wn9fawZclU5lsU4ECChqUnX88vHAeaI2T44y30Dl6A';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
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
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routerDelegate: AppRoutes.router.routerDelegate,
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
    );
  }
}
