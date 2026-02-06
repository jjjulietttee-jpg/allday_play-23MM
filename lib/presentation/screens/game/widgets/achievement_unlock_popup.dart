import 'package:flutter/material.dart';
import '../../../../domain/entities/achievement.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/custom_text.dart';

/// Popup to show newly unlocked achievements
class AchievementUnlockPopup {
  static void show(BuildContext context, List<Achievement> achievements) {
    if (achievements.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.warning,
                size: 64,
              ),
              const SizedBox(height: 16),
              const CustomText(
                text: 'Achievement Unlocked!',
                style: AppTypography.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...achievements.map((achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        achievement.icon,
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: achievement.title,
                              style: AppTypography.body1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomText(
                              text: achievement.description,
                              style: AppTypography.body2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Awesome!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
