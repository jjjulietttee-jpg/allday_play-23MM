import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/custom_text.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_state.dart';
import '../../bloc/profile_event.dart';
import '../../../domain/entities/user_profile.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Progress screen displaying user progress with real data from profile.
/// 
/// This screen uses a CustomScrollView with SliverAppBar and SliverList
/// to display user progress items with real stats. Each item shows a title,
/// progress indicator, and current/target values.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    // Reload profile data when opening progress screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.profile == null) {
            return const Center(
              child: CustomText(text: 'No progress data'),
            );
          }

          final profile = state.profile!;
          final progressItems = _buildProgressItems(profile, state);

          return CustomScrollView(
            slivers: [
              // SliverAppBar with background and title
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: CustomText(
                    text: 'Your Progress',
                    style: AppTypography.heading2,
                  ),
                  centerTitle: true,
                ),
              ),
              
              // SliverList with real progress items
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final progressItem = progressItems[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 16 : 12,
                          bottom: index == progressItems.length - 1 ? 16 : 0,
                        ),
                        child: CardWidget(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Progress title with icon
                              Row(
                                children: [
                                  Icon(
                                    progressItem['icon'] as IconData,
                                    color: _getProgressColor(progressItem['progress'] as double),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomText(
                                      text: progressItem['title'] as String,
                                      style: AppTypography.body1.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Progress indicator
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: progressItem['progress'] as double,
                                  minHeight: 10,
                                  backgroundColor: AppColors.surface.withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getProgressColor(progressItem['progress'] as double),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Current/Target text
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: progressItem['subtitle'] as String,
                                    style: AppTypography.body2,
                                  ),
                                  CustomText(
                                    text: '${((progressItem['progress'] as double) * 100).toInt()}%',
                                    style: AppTypography.body1.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: _getProgressColor(progressItem['progress'] as double),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: progressItems.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build progress items from user profile
  List<Map<String, dynamic>> _buildProgressItems(UserProfile profile, ProfileState state) {
    return [
      {
        'icon': Icons.videogame_asset,
        'title': 'Games Played',
        'subtitle': '${profile.totalGamesPlayed} / 100 games',
        'progress': (profile.totalGamesPlayed / 100).clamp(0.0, 1.0),
      },
      {
        'icon': Icons.star,
        'title': 'Total Score',
        'subtitle': '${profile.totalScore} / 50,000 points',
        'progress': (profile.totalScore / 50000).clamp(0.0, 1.0),
      },
      {
        'icon': Icons.local_fire_department,
        'title': 'Best Combo',
        'subtitle': '${profile.longestCombo}x / 50x combo',
        'progress': (profile.longestCombo / 50).clamp(0.0, 1.0),
      },
      {
        'icon': Icons.trending_up,
        'title': 'Accuracy',
        'subtitle': '${profile.overallAccuracy.toStringAsFixed(1)}% / 95%',
        'progress': (profile.overallAccuracy / 95).clamp(0.0, 1.0),
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Achievements',
        'subtitle': '${state.unlockedCount} / ${state.totalCount} unlocked',
        'progress': state.totalCount > 0 ? (state.unlockedCount / state.totalCount) : 0.0,
      },
      {
        'icon': Icons.grade,
        'title': 'Level Progress',
        'subtitle': 'Level ${profile.level}',
        'progress': profile.levelProgress,
      },
    ];
  }

  /// Returns a color based on progress value for visual feedback
  Color _getProgressColor(double progress) {
    if (progress >= 0.8) {
      return AppColors.success;
    } else if (progress >= 0.5) {
      return AppColors.primary;
    } else if (progress >= 0.3) {
      return AppColors.warning;
    } else {
      return AppColors.accent;
    }
  }
}
