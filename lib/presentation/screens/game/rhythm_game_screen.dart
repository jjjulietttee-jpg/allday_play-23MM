import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/rhythm_game_bloc.dart';
import '../../bloc/rhythm_game_event.dart';
import '../../bloc/rhythm_game_state.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_state.dart';
import '../../bloc/profile_event.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_popup.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/audio_service.dart';
import 'widgets/game_lane.dart';
import 'widgets/hit_line.dart';
import 'widgets/game_stats_display.dart';
import 'widgets/hit_feedback_display.dart';
import 'widgets/achievement_unlock_popup.dart';

/// Main rhythm game screen
class RhythmGameScreen extends StatefulWidget {
  const RhythmGameScreen({super.key});

  @override
  State<RhythmGameScreen> createState() => _RhythmGameScreenState();
}

class _RhythmGameScreenState extends State<RhythmGameScreen> {
  final _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    print('🎮 Game screen initialized');
    // Запускаем фоновую музыку при старте игры
    Future.delayed(const Duration(milliseconds: 500), () {
      print('🎮 Starting background music...');
      _audioService.playBackgroundMusic();
    });
  }

  @override
  void dispose() {
    print('🎮 Game screen disposing - stopping music');
    // Останавливаем музыку при выходе из игры
    _audioService.stopBackgroundMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    
    return BlocProvider(
      create: (context) => RhythmGameBloc(profileBloc: profileBloc)
        ..add(const StartGame()),
      child: _RhythmGameView(audioService: _audioService),
    );
  }
}

class _RhythmGameView extends StatelessWidget {
  final AudioService audioService;
  
  const _RhythmGameView({required this.audioService});

  void _showPauseMenu(BuildContext context) {
    final gameBloc = context.read<RhythmGameBloc>();
    final profileBloc = context.read<ProfileBloc>();
    
    gameBloc.add(const PauseGame());
    audioService.pauseBackgroundMusic();
    
    CustomPopup.show(
      context,
      CustomPopup(
        title: 'Paused',
        content: const CustomText(
          text: 'Game is paused',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              gameBloc.add(const ResumeGame());
              audioService.resumeBackgroundMusic();
            },
            child: const Text('Resume'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Save current stats before restarting
              profileBloc.add(UpdateProfileWithGameStats(gameBloc.state.stats));
              gameBloc.add(const RestartGame());
              audioService.resumeBackgroundMusic();
            },
            child: const Text('Restart'),
          ),
          TextButton(
            onPressed: () {
              // Save current stats before quitting
              profileBloc.add(UpdateProfileWithGameStats(gameBloc.state.stats));
              audioService.stopBackgroundMusic();
              Navigator.of(context).pop();
              context.go('/menu');
            },
            child: const Text('Quit'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, RhythmGameState state) {
    CustomPopup.show(
      context,
      CustomPopup(
        title: 'Game Over!',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Score: ${state.stats.score}',
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Grade: ${state.stats.grade}',
              style: AppTypography.heading2.copyWith(
                color: _getGradeColor(state.stats.grade),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: 'Accuracy: ${state.stats.accuracy.toStringAsFixed(1)}%',
              style: AppTypography.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Max Combo: ${state.stats.maxCombo}',
              style: AppTypography.body1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Perfect: ${state.stats.perfectHits} | Good: ${state.stats.goodHits} | OK: ${state.stats.okHits}',
              style: AppTypography.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/menu');
            },
            child: const Text('Menu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<RhythmGameBloc>().add(const RestartGame());
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'S':
        return AppColors.warning;
      case 'A':
        return AppColors.success;
      case 'B':
        return AppColors.primary;
      case 'C':
        return AppColors.accent;
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RhythmGameBloc, RhythmGameState>(
          listener: (context, state) {
            if (state.status == GameStatus.gameOver) {
              // Delay to show final state before dialog
              Future.delayed(const Duration(milliseconds: 500), () {
                if (context.mounted) {
                  _showGameOverDialog(context, state);
                }
              });
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, profileState) {
            if (profileState.newlyUnlockedAchievements.isNotEmpty) {
              // Show achievement unlock popup
              Future.delayed(const Duration(milliseconds: 800), () {
                if (context.mounted) {
                  AchievementUnlockPopup.show(
                    context,
                    profileState.newlyUnlockedAchievements,
                  );
                }
              });
            }
          },
        ),
      ],
      child: CustomScaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top bar with stats and pause button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<RhythmGameBloc, RhythmGameState>(
                      builder: (context, state) {
                        return const GameStatsDisplay();
                      },
                    ),
                    IconButton(
                      onPressed: () => _showPauseMenu(context),
                      icon: const Icon(
                        Icons.pause,
                        color: AppColors.textPrimary,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Game area
              Expanded(
                child: BlocBuilder<RhythmGameBloc, RhythmGameState>(
                  builder: (context, state) {
                    return Stack(
                      children: [
                        // Lanes
                        Row(
                          children: List.generate(
                            RhythmGameBloc.numberOfLanes,
                            (index) => Expanded(
                              child: GameLane(
                                laneIndex: index,
                                notes: state.notes
                                    .where((note) => note.lane == index)
                                    .toList(),
                                onTap: () {
                                  // Воспроизводим звук тапа
                                  audioService.playTapSound();
                                  context.read<RhythmGameBloc>().add(TapLane(index));
                                },
                                isHighlighted: state.lastHitLane == index,
                              ),
                            ),
                          ),
                        ),
                        
                        // Hit line
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 100,
                          child: HitLine(),
                        ),
                        
                        // Hit feedback
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 150,
                          child: HitFeedbackDisplay(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              // Bottom padding
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
