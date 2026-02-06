import 'package:equatable/equatable.dart';

/// Represents the current game statistics
class GameStats extends Equatable {
  /// Current score
  final int score;
  
  /// Current combo count
  final int combo;
  
  /// Highest combo achieved in this session
  final int maxCombo;
  
  /// Number of perfect hits
  final int perfectHits;
  
  /// Number of good hits
  final int goodHits;
  
  /// Number of ok hits
  final int okHits;
  
  /// Number of missed notes
  final int missedNotes;
  
  /// Total notes spawned
  final int totalNotes;

  const GameStats({
    this.score = 0,
    this.combo = 0,
    this.maxCombo = 0,
    this.perfectHits = 0,
    this.goodHits = 0,
    this.okHits = 0,
    this.missedNotes = 0,
    this.totalNotes = 0,
  });

  /// Creates a copy with updated fields
  GameStats copyWith({
    int? score,
    int? combo,
    int? maxCombo,
    int? perfectHits,
    int? goodHits,
    int? okHits,
    int? missedNotes,
    int? totalNotes,
  }) {
    return GameStats(
      score: score ?? this.score,
      combo: combo ?? this.combo,
      maxCombo: maxCombo ?? this.maxCombo,
      perfectHits: perfectHits ?? this.perfectHits,
      goodHits: goodHits ?? this.goodHits,
      okHits: okHits ?? this.okHits,
      missedNotes: missedNotes ?? this.missedNotes,
      totalNotes: totalNotes ?? this.totalNotes,
    );
  }

  /// Calculate accuracy percentage
  double get accuracy {
    if (totalNotes == 0) return 100.0;
    final hits = perfectHits + goodHits + okHits;
    return (hits / totalNotes) * 100;
  }

  /// Get letter grade based on accuracy
  String get grade {
    if (accuracy >= 95) return 'S';
    if (accuracy >= 90) return 'A';
    if (accuracy >= 80) return 'B';
    if (accuracy >= 70) return 'C';
    if (accuracy >= 60) return 'D';
    return 'F';
  }

  @override
  List<Object?> get props => [
        score,
        combo,
        maxCombo,
        perfectHits,
        goodHits,
        okHits,
        missedNotes,
        totalNotes,
      ];
}
