import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/rhythm_game_bloc.dart';
import '../../../bloc/rhythm_game_state.dart';
import '../../../widgets/custom_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Displays hit feedback (Perfect, Good, OK, Miss)
class HitFeedbackDisplay extends StatelessWidget {
  const HitFeedbackDisplay({super.key});

  String _getFeedbackText(HitFeedback feedback) {
    switch (feedback) {
      case HitFeedback.perfect:
        return 'PERFECT!';
      case HitFeedback.good:
        return 'GOOD!';
      case HitFeedback.ok:
        return 'OK';
      case HitFeedback.miss:
        return 'MISS';
      case HitFeedback.none:
        return '';
    }
  }

  Color _getFeedbackColor(HitFeedback feedback) {
    switch (feedback) {
      case HitFeedback.perfect:
        return AppColors.warning;
      case HitFeedback.good:
        return AppColors.success;
      case HitFeedback.ok:
        return AppColors.primary;
      case HitFeedback.miss:
        return AppColors.error;
      case HitFeedback.none:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RhythmGameBloc, RhythmGameState>(
      builder: (context, state) {
        if (state.hitFeedback == HitFeedback.none) {
          return const SizedBox.shrink();
        }

        return Center(
          child: AnimatedOpacity(
            opacity: state.hitFeedback != HitFeedback.none ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 100),
            child: AnimatedScale(
              scale: state.hitFeedback != HitFeedback.none ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 100),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _getFeedbackColor(state.hitFeedback).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _getFeedbackColor(state.hitFeedback).withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CustomText(
                  text: _getFeedbackText(state.hitFeedback),
                  style: AppTypography.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
