import 'package:flutter/material.dart';

/// Brand color palette: dark base + vibrant accent.
/// Safe for app store review (no gambling/casino associations).
class AppColors {
  AppColors._();

  // Primary brand — energetic lime/green accent
  static const primary = Color(0xFF00E676);
  static const primaryDark = Color(0xFF00C853);
  static const primaryLight = Color(0xFF69F0AE);

  // Secondary accent — amber/gold for highlights
  static const accent = Color(0xFFFFB300);
  static const accentLight = Color(0xFFFFCA28);

  // Dark backgrounds
  static const background = Color(0xFF0D0D0D);
  static const surface = Color(0xFF1A1A1A);
  static const surfaceElevated = Color(0xFF242424);
  static const overlay = Color(0x80000000);

  // Text
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);

  // Semantic
  static const success = Color(0xFF00E676);
  static const warning = Color(0xFFFFB300);
  static const error = Color(0xFFE53935);
}
