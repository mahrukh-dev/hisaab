import 'package:flutter/material.dart';

/// Defines the Material 3 light and dark themes for Hisaab.
abstract class AppTheme {
  /// Seed color for the color scheme.
  static const Color seedColor = Color(0xFF006C4C); // Deep Emerald / Green

  /// Light theme configuration.
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        // scaffoldBackgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }

  /// Dark theme configuration.
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }
}
