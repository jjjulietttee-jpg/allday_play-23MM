import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

/// Prominent CTA button: bold, high contrast, brand accent.
class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final EdgeInsets? padding;

  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final fg = textColor ?? AppColors.background;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 56,
        minWidth: width ?? 0,
        maxWidth: width ?? double.infinity,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: AppTypography.button.copyWith(color: fg),
        ),
        child: Text(text),
      ),
    );
  }
}
