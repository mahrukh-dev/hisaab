import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/core/router/app_router.dart';
import 'package:hisaab/core/theme/app_theme.dart';
import 'package:hisaab/features/security/app_lock_gate.dart';

void main() {
  runApp(
    const ProviderScope(
      child: HisaabApp(),
    ),
  );
}

/// Root widget for Hisaab app.
class HisaabApp extends StatelessWidget {
  /// Creates a [HisaabApp].
  const HisaabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hisaab',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
      builder: (context, child) {
        return AppLockGate(
          enabled: true,
          autoLockMinutes: 5,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
