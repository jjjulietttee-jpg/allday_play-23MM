import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// A reusable text widget with friendly typography and overflow handling.
/// 
/// This widget provides consistent text styling across the application
/// with automatic overflow handling using ellipsis by default.
/// 
/// Example usage:
/// ```dart
/// CustomText(
///   text: 'Hello World',
///   style: AppTypography.heading1,
///   textAlign: TextAlign.center,
/// )
/// ```
class CustomText extends StatelessWidget {
  /// The text to display
  final String text;
  
  /// Optional text style. If not provided, uses theme's default body text style
  final TextStyle? style;
  
  /// How the text should be aligned horizontally
  final TextAlign? textAlign;
  
  /// Maximum number of lines for the text to span
  final int? maxLines;
  
  /// How visual overflow should be handled
  final TextOverflow? overflow;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? AppTypography.body1,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
