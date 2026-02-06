import 'package:flutter/material.dart';
import '../../../../domain/entities/rhythm_note.dart';

/// Widget representing a single rhythm note
class RhythmNoteWidget extends StatelessWidget {
  final RhythmNote note;
  final Color color;

  const RhythmNoteWidget({
    super.key,
    required this.note,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Don't render if note is hit or missed
    if (note.isHit || note.isMissed) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final noteSize = constraints.maxWidth * 0.8;
        final verticalPosition = constraints.maxHeight * note.position;
        final topPosition = verticalPosition - (noteSize / 2);
        final leftPosition = (constraints.maxWidth - noteSize) / 2;

        // Clamp positions to prevent overflow
        final clampedTop = topPosition.clamp(0.0, constraints.maxHeight - noteSize);
        final clampedLeft = leftPosition.clamp(0.0, constraints.maxWidth - noteSize);

        return Stack(
          children: [
            Positioned(
              top: clampedTop,
              left: clampedLeft,
              child: AnimatedOpacity(
                opacity: note.isHit ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: noteSize,
                  height: noteSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: noteSize * 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
