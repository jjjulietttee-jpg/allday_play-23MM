import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Bold typography for brand style (no gambling references).
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Roboto';

  static const heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    letterSpacing: -0.5,
  );

  static const heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );

  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
}

/// Application theme: dark base, vibrant accent, bold typography.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.accent,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: AppTypography.fontFamily,
  brightness: Brightness.dark,

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: AppTypography.button,
    ),
  ),

  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: AppTypography.heading2,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),

  textTheme: const TextTheme(
    displayLarge: AppTypography.heading1,
    displayMedium: AppTypography.heading2,
    bodyLarge: AppTypography.body1,
    bodyMedium: AppTypography.body2,
    labelLarge: AppTypography.button,
  ),
);
