import 'package:equatable/equatable.dart';
import '../../domain/entities/rhythm_note.dart';
import '../../domain/entities/game_stats.dart';

/// Enum representing the current game status
enum GameStatus {
  initial,
  playing,
  paused,
  gameOver,
}

/// Enum representing hit feedback
enum HitFeedback {
  none,
  perfect,
  good,
  ok,
  miss,
}

/// State for the rhythm game
class RhythmGameState extends Equatable {
  /// Current game status
  final GameStatus status;
  
  /// List of active notes on screen
  final List<RhythmNote> notes;
  
  /// Current game statistics
  final GameStats stats;
  
  /// Current game speed multiplier
  final double speed;
  
  /// Time elapsed since game start (in seconds)
  final double elapsedTime;
  
  /// Current hit feedback to display
  final HitFeedback hitFeedback;
  
  /// Lane that was just hit (for visual feedback)
  final int? lastHitLane;
  
  /// Timestamp of last feedback (to clear it after animation)
  final DateTime? lastFeedbackTime;

  const RhythmGameState({
    this.status = GameStatus.initial,
    this.notes = const [],
    this.stats = const GameStats(),
    this.speed = 1.0,
    this.elapsedTime = 0.0,
    this.hitFeedback = HitFeedback.none,
    this.lastHitLane,
    this.lastFeedbackTime,
  });

  /// Creates a copy with updated fields
  RhythmGameState copyWith({
    GameStatus? status,
    List<RhythmNote>? notes,
    GameStats? stats,
    double? speed,
    double? elapsedTime,
    HitFeedback? hitFeedback,
    int? lastHitLane,
    DateTime? lastFeedbackTime,
    bool clearLastHitLane = false,
    bool clearFeedback = false,
  }) {
    return RhythmGameState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      stats: stats ?? this.stats,
      speed: speed ?? this.speed,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      hitFeedback: clearFeedback ? HitFeedback.none : (hitFeedback ?? this.hitFeedback),
      lastHitLane: clearLastHitLane ? null : (lastHitLane ?? this.lastHitLane),
      lastFeedbackTime: clearFeedback ? null : (lastFeedbackTime ?? this.lastFeedbackTime),
    );
  }

  @override
  List<Object?> get props => [
        status,
        notes,
        stats,
        speed,
        elapsedTime,
        hitFeedback,
        lastHitLane,
        lastFeedbackTime,
      ];
}
