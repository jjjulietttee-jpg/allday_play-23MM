import 'package:equatable/equatable.dart';

/// Achievement entity
class Achievement extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int targetValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetValue,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? targetValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      targetValue: targetValue ?? this.targetValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        targetValue,
        isUnlocked,
        unlockedAt,
      ];
}

/// Predefined achievements
class Achievements {
  static const List<Achievement> all = [
    Achievement(
      id: 'first_game',
      title: 'First Steps',
      description: 'Play your first game',
      icon: '🎮',
      targetValue: 1,
    ),
    Achievement(
      id: 'score_1000',
      title: 'Rising Star',
      description: 'Score 1000 points in a single game',
      icon: '⭐',
      targetValue: 1000,
    ),
    Achievement(
      id: 'score_5000',
      title: 'Pro Player',
      description: 'Score 5000 points in a single game',
      icon: '🌟',
      targetValue: 5000,
    ),
    Achievement(
      id: 'score_10000',
      title: 'Master',
      description: 'Score 10000 points in a single game',
      icon: '👑',
      targetValue: 10000,
    ),
    Achievement(
      id: 'combo_10',
      title: 'Combo Starter',
      description: 'Achieve a 10x combo',
      icon: '🔥',
      targetValue: 10,
    ),
    Achievement(
      id: 'combo_25',
      title: 'Combo Master',
      description: 'Achieve a 25x combo',
      icon: '💥',
      targetValue: 25,
    ),
    Achievement(
      id: 'combo_50',
      title: 'Unstoppable',
      description: 'Achieve a 50x combo',
      icon: '⚡',
      targetValue: 50,
    ),
    Achievement(
      id: 'perfect_10',
      title: 'Perfectionist',
      description: 'Hit 10 perfect notes in a row',
      icon: '💎',
      targetValue: 10,
    ),
    Achievement(
      id: 'games_10',
      title: 'Dedicated',
      description: 'Play 10 games',
      icon: '🎯',
      targetValue: 10,
    ),
    Achievement(
      id: 'games_50',
      title: 'Veteran',
      description: 'Play 50 games',
      icon: '🏆',
      targetValue: 50,
    ),
    Achievement(
      id: 'games_100',
      title: 'Legend',
      description: 'Play 100 games',
      icon: '🎖️',
      targetValue: 100,
    ),
    Achievement(
      id: 'total_score_10000',
      title: 'Score Hunter',
      description: 'Reach 10,000 total score',
      icon: '💰',
      targetValue: 10000,
    ),
  ];
}
