import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryBlue,
        onPrimary: AppColors.onPrimaryBlue,
        primaryContainer: AppColors.primaryBlueLight,
        onPrimaryContainer: AppColors.primaryBlueDark,
        secondary: AppColors.secondaryTeal,
        onSecondary: AppColors.onPrimaryBlue,
        secondaryContainer: AppColors.secondaryTealLight,
        onSecondaryContainer: AppColors.secondaryTeal,
        error: AppColors.alertRed,
        onError: AppColors.onPrimaryBlue,
        errorContainer: AppColors.alertRedLight,
        onErrorContainer: AppColors.alertRed,
        surface: AppColors.surfaceWhite,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceCard,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.surfaceBorder,
      ),
      scaffoldBackgroundColor: AppColors.surfaceWhite,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.onPrimaryBlue,
        elevation: 0,
        centerTitle: false,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.onPrimaryBlue,
      ),
    );
  }
}
