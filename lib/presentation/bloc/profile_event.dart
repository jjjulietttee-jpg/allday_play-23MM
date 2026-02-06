import 'package:equatable/equatable.dart';
import '../../domain/entities/game_stats.dart';

/// Base class for profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load profile data
class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

/// Update player name
class UpdatePlayerName extends ProfileEvent {
  final String name;

  const UpdatePlayerName(this.name);

  @override
  List<Object?> get props => [name];
}

/// Update profile with game stats
class UpdateProfileWithGameStats extends ProfileEvent {
  final GameStats stats;

  const UpdateProfileWithGameStats(this.stats);

  @override
  List<Object?> get props => [stats];
}

/// Reset all data
class ResetAllData extends ProfileEvent {
  const ResetAllData();
}
