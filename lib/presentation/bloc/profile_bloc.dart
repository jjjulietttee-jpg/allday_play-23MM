import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/entities/user_profile.dart';

/// BLoC for managing user profile
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdatePlayerName>(_onUpdatePlayerName);
    on<UpdateProfileWithGameStats>(_onUpdateProfileWithGameStats);
    on<ResetAllData>(_onResetAllData);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final profile = await _repository.loadProfile();
      final achievements = await _repository.loadAchievements();

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        achievements: achievements,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdatePlayerName(
    UpdatePlayerName event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final updatedProfile = await _repository.updatePlayerName(event.name);
      emit(state.copyWith(profile: updatedProfile));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfileWithGameStats(
    UpdateProfileWithGameStats event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final updatedProfile = await _repository.updateWithGameStats(event.stats);
      final newlyUnlocked = await _repository.checkAndUnlockAchievements(
        updatedProfile,
        event.stats,
      );
      final achievements = await _repository.loadAchievements();

      emit(state.copyWith(
        profile: updatedProfile,
        achievements: achievements,
        newlyUnlockedAchievements: newlyUnlocked,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onResetAllData(
    ResetAllData event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _repository.resetAllData();
      
      // Create new default profile
      final now = DateTime.now();
      final defaultProfile = UserProfile(
        playerName: 'Player',
        createdAt: now,
        lastPlayedAt: now,
      );
      
      await _repository.saveProfile(defaultProfile);
      final achievements = await _repository.loadAchievements();

      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: defaultProfile,
        achievements: achievements,
        clearNewlyUnlocked: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
