import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/game_stats.dart';

/// Repository for managing user data with SharedPreferences
class UserRepository {
  static const String _keyPlayerName = 'player_name';
  static const String _keyTotalGamesPlayed = 'total_games_played';
  static const String _keyTotalScore = 'total_score';
  static const String _keyHighestScore = 'highest_score';
  static const String _keyTotalPerfectHits = 'total_perfect_hits';
  static const String _keyTotalGoodHits = 'total_good_hits';
  static const String _keyTotalOkHits = 'total_ok_hits';
  static const String _keyTotalMisses = 'total_misses';
  static const String _keyLongestCombo = 'longest_combo';
  static const String _keyTotalNotesHit = 'total_notes_hit';
  static const String _keyCreatedAt = 'created_at';
  static const String _keyLastPlayedAt = 'last_played_at';
  static const String _keyUnlockedAchievements = 'unlocked_achievements';
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  final SharedPreferences _prefs;

  UserRepository(this._prefs);

  /// Load user profile
  Future<UserProfile> loadProfile() async {
    final playerName = _prefs.getString(_keyPlayerName) ?? 'Player';
    final totalGamesPlayed = _prefs.getInt(_keyTotalGamesPlayed) ?? 0;
    final totalScore = _prefs.getInt(_keyTotalScore) ?? 0;
    final highestScore = _prefs.getInt(_keyHighestScore) ?? 0;
    final totalPerfectHits = _prefs.getInt(_keyTotalPerfectHits) ?? 0;
    final totalGoodHits = _prefs.getInt(_keyTotalGoodHits) ?? 0;
    final totalOkHits = _prefs.getInt(_keyTotalOkHits) ?? 0;
    final totalMisses = _prefs.getInt(_keyTotalMisses) ?? 0;
    final longestCombo = _prefs.getInt(_keyLongestCombo) ?? 0;
    final totalNotesHit = _prefs.getInt(_keyTotalNotesHit) ?? 0;
    
    final createdAtMs = _prefs.getInt(_keyCreatedAt);
    final lastPlayedAtMs = _prefs.getInt(_keyLastPlayedAt);
    
    final now = DateTime.now();
    final createdAt = createdAtMs != null 
        ? DateTime.fromMillisecondsSinceEpoch(createdAtMs)
        : now;
    final lastPlayedAt = lastPlayedAtMs != null
        ? DateTime.fromMillisecondsSinceEpoch(lastPlayedAtMs)
        : now;

    return UserProfile(
      playerName: playerName,
      totalGamesPlayed: totalGamesPlayed,
      totalScore: totalScore,
      highestScore: highestScore,
      totalPerfectHits: totalPerfectHits,
      totalGoodHits: totalGoodHits,
      totalOkHits: totalOkHits,
      totalMisses: totalMisses,
      longestCombo: longestCombo,
      totalNotesHit: totalNotesHit,
      createdAt: createdAt,
      lastPlayedAt: lastPlayedAt,
    );
  }

  /// Save user profile
  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_keyPlayerName, profile.playerName);
    await _prefs.setInt(_keyTotalGamesPlayed, profile.totalGamesPlayed);
    await _prefs.setInt(_keyTotalScore, profile.totalScore);
    await _prefs.setInt(_keyHighestScore, profile.highestScore);
    await _prefs.setInt(_keyTotalPerfectHits, profile.totalPerfectHits);
    await _prefs.setInt(_keyTotalGoodHits, profile.totalGoodHits);
    await _prefs.setInt(_keyTotalOkHits, profile.totalOkHits);
    await _prefs.setInt(_keyTotalMisses, profile.totalMisses);
    await _prefs.setInt(_keyLongestCombo, profile.longestCombo);
    await _prefs.setInt(_keyTotalNotesHit, profile.totalNotesHit);
    await _prefs.setInt(_keyCreatedAt, profile.createdAt.millisecondsSinceEpoch);
    await _prefs.setInt(_keyLastPlayedAt, profile.lastPlayedAt.millisecondsSinceEpoch);
  }

  /// Update profile with game stats
  Future<UserProfile> updateWithGameStats(GameStats stats) async {
    final profile = await loadProfile();
    
    final updatedProfile = profile.copyWith(
      totalGamesPlayed: profile.totalGamesPlayed + 1,
      totalScore: profile.totalScore + stats.score,
      highestScore: stats.score > profile.highestScore ? stats.score : profile.highestScore,
      totalPerfectHits: profile.totalPerfectHits + stats.perfectHits,
      totalGoodHits: profile.totalGoodHits + stats.goodHits,
      totalOkHits: profile.totalOkHits + stats.okHits,
      totalMisses: profile.totalMisses + stats.missedNotes,
      longestCombo: stats.maxCombo > profile.longestCombo ? stats.maxCombo : profile.longestCombo,
      totalNotesHit: profile.totalNotesHit + stats.perfectHits + stats.goodHits + stats.okHits,
      lastPlayedAt: DateTime.now(),
    );
    
    await saveProfile(updatedProfile);
    return updatedProfile;
  }

  /// Update player name
  Future<UserProfile> updatePlayerName(String name) async {
    final profile = await loadProfile();
    final updatedProfile = profile.copyWith(playerName: name);
    await saveProfile(updatedProfile);
    return updatedProfile;
  }

  /// Load unlocked achievements
  Future<List<Achievement>> loadAchievements() async {
    final unlockedIds = _prefs.getStringList(_keyUnlockedAchievements) ?? [];
    
    return Achievements.all.map((achievement) {
      final isUnlocked = unlockedIds.contains(achievement.id);
      return achievement.copyWith(
        isUnlocked: isUnlocked,
        unlockedAt: isUnlocked ? DateTime.now() : null,
      );
    }).toList();
  }

  /// Check and unlock achievements based on profile
  Future<List<Achievement>> checkAndUnlockAchievements(UserProfile profile, GameStats? currentGameStats) async {
    final achievements = await loadAchievements();
    final unlockedIds = _prefs.getStringList(_keyUnlockedAchievements) ?? [];
    final newlyUnlocked = <Achievement>[];

    for (final achievement in achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_game':
          shouldUnlock = profile.totalGamesPlayed >= 1;
          break;
        case 'score_1000':
          shouldUnlock = currentGameStats != null && currentGameStats.score >= 1000;
          break;
        case 'score_5000':
          shouldUnlock = currentGameStats != null && currentGameStats.score >= 5000;
          break;
        case 'score_10000':
          shouldUnlock = currentGameStats != null && currentGameStats.score >= 10000;
          break;
        case 'combo_10':
          shouldUnlock = profile.longestCombo >= 10;
          break;
        case 'combo_25':
          shouldUnlock = profile.longestCombo >= 25;
          break;
        case 'combo_50':
          shouldUnlock = profile.longestCombo >= 50;
          break;
        case 'perfect_10':
          shouldUnlock = currentGameStats != null && currentGameStats.perfectHits >= 10;
          break;
        case 'games_10':
          shouldUnlock = profile.totalGamesPlayed >= 10;
          break;
        case 'games_50':
          shouldUnlock = profile.totalGamesPlayed >= 50;
          break;
        case 'games_100':
          shouldUnlock = profile.totalGamesPlayed >= 100;
          break;
        case 'total_score_10000':
          shouldUnlock = profile.totalScore >= 10000;
          break;
      }

      if (shouldUnlock) {
        unlockedIds.add(achievement.id);
        newlyUnlocked.add(achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        ));
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      await _prefs.setStringList(_keyUnlockedAchievements, unlockedIds);
    }

    return newlyUnlocked;
  }

  /// Reset all data (for testing)
  Future<void> resetAllData() async {
    await _prefs.clear();
  }

  /// Check if onboarding was completed
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_keyOnboardingCompleted, true);
  }
}
