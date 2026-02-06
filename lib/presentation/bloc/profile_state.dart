import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/achievement.dart';

/// Profile state status
enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

/// State for user profile
class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? profile;
  final List<Achievement> achievements;
  final List<Achievement> newlyUnlockedAchievements;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.achievements = const [],
    this.newlyUnlockedAchievements = const [],
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    List<Achievement>? achievements,
    List<Achievement>? newlyUnlockedAchievements,
    String? errorMessage,
    bool clearNewlyUnlocked = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      achievements: achievements ?? this.achievements,
      newlyUnlockedAchievements: clearNewlyUnlocked 
          ? [] 
          : (newlyUnlockedAchievements ?? this.newlyUnlockedAchievements),
      errorMessage: errorMessage,
    );
  }

  /// Get unlocked achievements count
  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;

  /// Get total achievements count
  int get totalCount => achievements.length;

  /// Get achievement progress percentage
  double get achievementProgress {
    if (totalCount == 0) return 0.0;
    return (unlockedCount / totalCount) * 100;
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        achievements,
        newlyUnlockedAchievements,
        errorMessage,
      ];
}
