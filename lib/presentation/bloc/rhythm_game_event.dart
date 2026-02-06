import 'package:equatable/equatable.dart';

/// Base class for all rhythm game events
abstract class RhythmGameEvent extends Equatable {
  const RhythmGameEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start a new game
class StartGame extends RhythmGameEvent {
  const StartGame();
}

/// Event to pause the game
class PauseGame extends RhythmGameEvent {
  const PauseGame();
}

/// Event to resume the game
class ResumeGame extends RhythmGameEvent {
  const ResumeGame();
}

/// Event to end the game
class EndGame extends RhythmGameEvent {
  const EndGame();
}

/// Event to restart the game
class RestartGame extends RhythmGameEvent {
  const RestartGame();
}

/// Event triggered on each game tick (frame update)
class GameTick extends RhythmGameEvent {
  final double deltaTime;

  const GameTick(this.deltaTime);

  @override
  List<Object?> get props => [deltaTime];
}

/// Event when a lane is tapped
class TapLane extends RhythmGameEvent {
  final int lane;

  const TapLane(this.lane);

  @override
  List<Object?> get props => [lane];
}

/// Event to spawn a new note
class SpawnNote extends RhythmGameEvent {
  const SpawnNote();
}
