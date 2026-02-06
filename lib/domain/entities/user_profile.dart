import 'package:equatable/equatable.dart';

/// User profile entity
class UserProfile extends Equatable {
  final String playerName;
  final int totalGamesPlayed;
  final int totalScore;
  final int highestScore;
  final int totalPerfectHits;
  final int totalGoodHits;
  final int totalOkHits;
  final int totalMisses;
  final int longestCombo;
  final int totalNotesHit;
  final DateTime createdAt;
  final DateTime lastPlayedAt;

  const UserProfile({
    required this.playerName,
    this.totalGamesPlayed = 0,
    this.totalScore = 0,
    this.highestScore = 0,
    this.totalPerfectHits = 0,
    this.totalGoodHits = 0,
    this.totalOkHits = 0,
    this.totalMisses = 0,
    this.longestCombo = 0,
    this.totalNotesHit = 0,
    required this.createdAt,
    required this.lastPlayedAt,
  });

  UserProfile copyWith({
    String? playerName,
    int? totalGamesPlayed,
    int? totalScore,
    int? highestScore,
    int? totalPerfectHits,
    int? totalGoodHits,
    int? totalOkHits,
    int? totalMisses,
    int? longestCombo,
    int? totalNotesHit,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) {
    return UserProfile(
      playerName: playerName ?? this.playerName,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalScore: totalScore ?? this.totalScore,
      highestScore: highestScore ?? this.highestScore,
      totalPerfectHits: totalPerfectHits ?? this.totalPerfectHits,
      totalGoodHits: totalGoodHits ?? this.totalGoodHits,
      totalOkHits: totalOkHits ?? this.totalOkHits,
      totalMisses: totalMisses ?? this.totalMisses,
      longestCombo: longestCombo ?? this.longestCombo,
      totalNotesHit: totalNotesHit ?? this.totalNotesHit,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
    );
  }

  /// Calculate overall accuracy
  double get overallAccuracy {
    final totalNotes = totalNotesHit + totalMisses;
    if (totalNotes == 0) return 0.0;
    return (totalNotesHit / totalNotes) * 100;
  }

  /// Calculate average score per game
  double get averageScore {
    if (totalGamesPlayed == 0) return 0.0;
    return totalScore / totalGamesPlayed;
  }

  /// Get player level based on total score
  int get level {
    return (totalScore / 1000).floor() + 1;
  }

  /// Get progress to next level (0.0 to 1.0)
  double get levelProgress {
    final currentLevelScore = (level - 1) * 1000;
    final nextLevelScore = level * 1000;
    final progressScore = totalScore - currentLevelScore;
    return progressScore / (nextLevelScore - currentLevelScore);
  }

  @override
  List<Object?> get props => [
        playerName,
        totalGamesPlayed,
        totalScore,
        highestScore,
        totalPerfectHits,
        totalGoodHits,
        totalOkHits,
        totalMisses,
        longestCombo,
        totalNotesHit,
        createdAt,
        lastPlayedAt,
      ];
}
