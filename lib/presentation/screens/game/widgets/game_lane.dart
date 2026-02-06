import 'package:flutter/material.dart';
import '../../../../domain/entities/rhythm_note.dart';
import '../../../../core/theme/app_colors.dart';
import 'rhythm_note_widget.dart';

/// Represents a single lane in the rhythm game
class GameLane extends StatelessWidget {
  final int laneIndex;
  final List<RhythmNote> notes;
  final VoidCallback onTap;
  final bool isHighlighted;

  const GameLane({
    super.key,
    required this.laneIndex,
    required this.notes,
    required this.onTap,
    this.isHighlighted = false,
  });

  Color get _laneColor {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.success,
      AppColors.warning,
    ];
    return colors[laneIndex % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          border: Border.all(
            color: _laneColor.withValues(alpha: 0.3),
            width: 2,
          ),
          color: isHighlighted
              ? _laneColor.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: ClipRect(
          child: Stack(
            children: notes.map((note) {
              return RhythmNoteWidget(
                note: note,
                color: _laneColor,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
