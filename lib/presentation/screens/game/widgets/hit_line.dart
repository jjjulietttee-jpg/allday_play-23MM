import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// The hit line where notes should be tapped
class HitLine extends StatelessWidget {
  const HitLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.textPrimary.withValues(alpha: 0.8),
            AppColors.textPrimary.withValues(alpha: 0.8),
            Colors.transparent,
          ],
          stops: const [0.0, 0.1, 0.9, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
