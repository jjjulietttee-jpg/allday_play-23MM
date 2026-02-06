import 'package:equatable/equatable.dart';

/// Represents a single rhythm note in the game
/// 
/// A note moves down a lane and must be tapped when it reaches the hit line.
class RhythmNote extends Equatable {
  /// Unique identifier for this note
  final String id;
  
  /// Lane number (0-3 for 4 lanes)
  final int lane;
  
  /// Current vertical position (0.0 = top, 1.0 = hit line)
  final double position;
  
  /// Whether this note has been hit
  final bool isHit;
  
  /// Whether this note was missed
  final bool isMissed;
  
  /// Timestamp when the note was created
  final DateTime createdAt;

  const RhythmNote({
    required this.id,
    required this.lane,
    required this.position,
    this.isHit = false,
    this.isMissed = false,
    required this.createdAt,
  });

  /// Creates a copy with updated fields
  RhythmNote copyWith({
    String? id,
    int? lane,
    double? position,
    bool? isHit,
    bool? isMissed,
    DateTime? createdAt,
  }) {
    return RhythmNote(
      id: id ?? this.id,
      lane: lane ?? this.lane,
      position: position ?? this.position,
      isHit: isHit ?? this.isHit,
      isMissed: isMissed ?? this.isMissed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Check if note is in the perfect hit zone
  bool get isPerfectHit => position >= 0.90 && position <= 1.0;
  
  /// Check if note is in the good hit zone
  bool get isGoodHit => position >= 0.85 && position <= 1.05;
  
  /// Check if note is in the ok hit zone
  bool get isOkHit => position >= 0.80 && position <= 1.10;
  
  /// Check if note has passed the hit line and should be marked as missed
  bool get shouldBeMissed => position > 1.15;

  @override
  List<Object?> get props => [id, lane, position, isHit, isMissed, createdAt];
}
