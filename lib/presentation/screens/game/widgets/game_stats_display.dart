import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/rhythm_game_bloc.dart';
import '../../../bloc/rhythm_game_state.dart';
import '../../../widgets/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Displays current game statistics
class GameStatsDisplay extends StatelessWidget {
  const GameStatsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RhythmGameBloc, RhythmGameState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score
            CustomText(
              text: 'Score: ${state.stats.score}',
              style: AppTypography.heading2.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),
            
            // Combo
            if (state.stats.combo > 0)
              CustomText(
                text: 'Combo: ${state.stats.combo}x',
                style: AppTypography.body1.copyWith(
                  color: state.stats.combo >= 10
                      ? AppColors.warning
                      : AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            
            // Speed indicator
            CustomText(
              text: 'Speed: ${state.speed.toStringAsFixed(1)}x',
              style: AppTypography.body2,
            ),
            
            // Misses indicator
            CustomText(
              text: 'Misses: ${state.stats.missedNotes}/10',
              style: AppTypography.body2.copyWith(
                color: state.stats.missedNotes >= 7
                    ? AppColors.error
                    : AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
