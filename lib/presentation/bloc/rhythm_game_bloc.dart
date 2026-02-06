import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'rhythm_game_event.dart';
import 'rhythm_game_state.dart';
import '../../domain/entities/rhythm_note.dart';
import 'profile_bloc.dart';
import 'profile_event.dart';

/// BLoC for managing rhythm game state and logic
class RhythmGameBloc extends Bloc<RhythmGameEvent, RhythmGameState> {
  /// Timer for game loop
  Timer? _gameTimer;
  
  /// Timer for spawning notes
  Timer? _spawnTimer;
  
  /// Random number generator for lane selection
  final Random _random = Random();
  
  /// Profile BLoC for saving stats
  final ProfileBloc? _profileBloc;
  
  /// Number of lanes in the game
  static const int numberOfLanes = 4;
  
  /// Base speed for note movement (units per second)
  static const double baseSpeed = 0.4;
  
  /// Interval for spawning notes (in seconds)
  static const double spawnInterval = 1.2;
  
  /// Speed increase per 10 seconds
  static const double speedIncreaseRate = 0.05;

  RhythmGameBloc({ProfileBloc? profileBloc}) 
      : _profileBloc = profileBloc,
        super(const RhythmGameState()) {
    on<StartGame>(_onStartGame);
    on<PauseGame>(_onPauseGame);
    on<ResumeGame>(_onResumeGame);
    on<EndGame>(_onEndGame);
    on<RestartGame>(_onRestartGame);
    on<GameTick>(_onGameTick);
    on<TapLane>(_onTapLane);
    on<SpawnNote>(_onSpawnNote);
  }

  /// Handle game start
  void _onStartGame(StartGame event, Emitter<RhythmGameState> emit) {
    // Cancel any existing timers
    _cancelTimers();
    
    // Reset state
    emit(const RhythmGameState(
      status: GameStatus.playing,
      speed: 1.0,
    ));
    
    // Start game loop (60 FPS)
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => add(GameTick(0.016)),
    );
    
    // Start spawning notes
    _spawnTimer = Timer.periodic(
      Duration(milliseconds: (spawnInterval * 1000).toInt()),
      (_) => add(const SpawnNote()),
    );
    
    // Spawn first note immediately
    add(const SpawnNote());
  }

  /// Handle game pause
  void _onPauseGame(PauseGame event, Emitter<RhythmGameState> emit) {
    if (state.status == GameStatus.playing) {
      _cancelTimers();
      emit(state.copyWith(status: GameStatus.paused));
    }
  }

  /// Handle game resume
  void _onResumeGame(ResumeGame event, Emitter<RhythmGameState> emit) {
    if (state.status == GameStatus.paused) {
      emit(state.copyWith(status: GameStatus.playing));
      
      // Restart timers
      _gameTimer = Timer.periodic(
        const Duration(milliseconds: 16),
        (_) => add(GameTick(0.016)),
      );
      
      _spawnTimer = Timer.periodic(
        Duration(milliseconds: (spawnInterval * 1000).toInt()),
        (_) => add(const SpawnNote()),
      );
    }
  }

  /// Handle game end
  void _onEndGame(EndGame event, Emitter<RhythmGameState> emit) {
    _cancelTimers();
    emit(state.copyWith(status: GameStatus.gameOver));
    
    // Save stats to profile
    _profileBloc?.add(UpdateProfileWithGameStats(state.stats));
  }

  /// Handle game restart
  void _onRestartGame(RestartGame event, Emitter<RhythmGameState> emit) {
    add(const StartGame());
  }

  /// Handle game tick (frame update)
  void _onGameTick(GameTick event, Emitter<RhythmGameState> emit) {
    if (state.status != GameStatus.playing) return;

    final newElapsedTime = state.elapsedTime + event.deltaTime;
    
    // Calculate speed increase based on elapsed time
    final speedMultiplier = 1.0 + (newElapsedTime / 10.0) * speedIncreaseRate;
    
    // Update note positions
    final updatedNotes = <RhythmNote>[];
    var updatedStats = state.stats;
    
    for (final note in state.notes) {
      if (note.isHit || note.isMissed) {
        // Remove hit or missed notes after a short delay
        continue;
      }
      
      // Move note down
      final newPosition = note.position + (baseSpeed * speedMultiplier * event.deltaTime);
      
      // Check if note should be marked as missed
      if (newPosition > 1.15 && !note.isMissed) {
        updatedStats = updatedStats.copyWith(
          missedNotes: updatedStats.missedNotes + 1,
          combo: 0,
        );
        updatedNotes.add(note.copyWith(
          position: newPosition,
          isMissed: true,
        ));
      } else {
        updatedNotes.add(note.copyWith(position: newPosition));
      }
    }
    
    // Check for game over condition (too many misses)
    if (updatedStats.missedNotes >= 10) {
      _cancelTimers();
      
      // Save stats to profile before game over
      _profileBloc?.add(UpdateProfileWithGameStats(updatedStats));
      
      emit(state.copyWith(
        status: GameStatus.gameOver,
        notes: updatedNotes,
        stats: updatedStats,
      ));
      return;
    }
    
    // Clear hit feedback after 0.3 seconds
    var newHitFeedback = state.hitFeedback;
    var newLastHitLane = state.lastHitLane;
    var newLastFeedbackTime = state.lastFeedbackTime;
    
    if (state.lastFeedbackTime != null) {
      final timeSinceFeedback = DateTime.now().difference(state.lastFeedbackTime!);
      if (timeSinceFeedback.inMilliseconds > 300) {
        newHitFeedback = HitFeedback.none;
        newLastHitLane = null;
        newLastFeedbackTime = null;
      }
    }
    
    emit(state.copyWith(
      notes: updatedNotes,
      stats: updatedStats,
      speed: speedMultiplier,
      elapsedTime: newElapsedTime,
      hitFeedback: newHitFeedback,
      lastHitLane: newLastHitLane,
      lastFeedbackTime: newLastFeedbackTime,
    ));
  }

  /// Handle lane tap
  void _onTapLane(TapLane event, Emitter<RhythmGameState> emit) {
    if (state.status != GameStatus.playing) return;

    // Find the closest note in the tapped lane
    RhythmNote? closestNote;
    double closestDistance = double.infinity;
    
    for (final note in state.notes) {
      if (note.lane == event.lane && !note.isHit && !note.isMissed) {
        final distance = (note.position - 1.0).abs();
        if (distance < closestDistance) {
          closestDistance = distance;
          closestNote = note;
        }
      }
    }
    
    if (closestNote == null) {
      // No note to hit - could add penalty here if desired
      return;
    }
    
    // Determine hit quality
    HitFeedback feedback;
    int scoreGain;
    var updatedStats = state.stats;
    
    if (closestNote.isPerfectHit) {
      feedback = HitFeedback.perfect;
      scoreGain = 100 + (state.stats.combo * 10);
      updatedStats = updatedStats.copyWith(
        perfectHits: updatedStats.perfectHits + 1,
        combo: updatedStats.combo + 1,
      );
    } else if (closestNote.isGoodHit) {
      feedback = HitFeedback.good;
      scoreGain = 50 + (state.stats.combo * 5);
      updatedStats = updatedStats.copyWith(
        goodHits: updatedStats.goodHits + 1,
        combo: updatedStats.combo + 1,
      );
    } else if (closestNote.isOkHit) {
      feedback = HitFeedback.ok;
      scoreGain = 25;
      updatedStats = updatedStats.copyWith(
        okHits: updatedStats.okHits + 1,
        combo: 0,
      );
    } else {
      // Too far from hit line
      return;
    }
    
    // Update stats
    updatedStats = updatedStats.copyWith(
      score: updatedStats.score + scoreGain,
      maxCombo: max(updatedStats.maxCombo, updatedStats.combo),
    );
    
    // Mark note as hit
    final updatedNotes = state.notes.map((note) {
      if (note.id == closestNote!.id) {
        return note.copyWith(isHit: true);
      }
      return note;
    }).toList();
    
    emit(state.copyWith(
      notes: updatedNotes,
      stats: updatedStats,
      hitFeedback: feedback,
      lastHitLane: event.lane,
      lastFeedbackTime: DateTime.now(),
    ));
  }

  /// Handle note spawn
  void _onSpawnNote(SpawnNote event, Emitter<RhythmGameState> emit) {
    if (state.status != GameStatus.playing) return;

    // Generate random lane
    final lane = _random.nextInt(numberOfLanes);
    
    // Create new note
    final note = RhythmNote(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      lane: lane,
      position: 0.0,
      createdAt: DateTime.now(),
    );
    
    // Add note to state
    final updatedNotes = [...state.notes, note];
    final updatedStats = state.stats.copyWith(
      totalNotes: state.stats.totalNotes + 1,
    );
    
    emit(state.copyWith(
      notes: updatedNotes,
      stats: updatedStats,
    ));
  }

  /// Cancel all timers
  void _cancelTimers() {
    _gameTimer?.cancel();
    _gameTimer = null;
    _spawnTimer?.cancel();
    _spawnTimer = null;
  }

  @override
  Future<void> close() {
    _cancelTimers();
    return super.close();
  }
}
