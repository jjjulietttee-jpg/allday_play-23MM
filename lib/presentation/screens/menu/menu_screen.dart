import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/card_widget.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_state.dart';
import '../../bloc/profile_event.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';

/// Main menu screen with Sliver-based layout and navigation options.
///
/// This screen serves as the main navigation hub of the application,
/// featuring a collapsible app bar with background image and navigation
/// buttons to different sections of the app. Displays real user stats.
class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
    // Reload profile data when returning to menu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfile());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      useSafeArea: false,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profile = state.profile;
          
          return CustomScrollView(
            slivers: [
              // SliverAppBar — прозрачный, одна полноэкранная bg.png из CustomScaffold
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: const CustomText(
                    text: 'Menu',
                    style: AppTypography.heading2,
                  ),
                  background: Container(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Main content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome message with player name
                      CustomText(
                        text: profile != null 
                            ? 'Welcome back, ${profile.playerName}!'
                            : 'Welcome back! Ready to go?',
                        style: AppTypography.heading2,
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Stats Card (if profile exists)
                      if (profile != null) ...[
                        CardWidget(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.emoji_events,
                                    color: AppColors.warning,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  const CustomText(
                                    text: 'Your Stats',
                                    style: AppTypography.heading2,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem(
                                    icon: Icons.grade,
                                    label: 'Level',
                                    value: '${profile.level}',
                                    color: AppColors.warning,
                                  ),
                                  _buildStatItem(
                                    icon: Icons.star,
                                    label: 'High Score',
                                    value: '${profile.highestScore}',
                                    color: AppColors.primary,
                                  ),
                                  _buildStatItem(
                                    icon: Icons.videogame_asset,
                                    label: 'Games',
                                    value: '${profile.totalGamesPlayed}',
                                    color: AppColors.accent,
                                  ),
                                ],
                              ),
                              if (state.unlockedCount > 0) ...[
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.emoji_events,
                                        color: AppColors.success,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      CustomText(
                                        text: '${state.unlockedCount} / ${state.totalCount} Achievements',
                                        style: AppTypography.body1.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      
                      // Primary button - Start Playing
                      CustomElevatedButton(
                        text: 'Start',
                        onPressed: () => context.push('/game-tutorial'),
                        backgroundColor: AppColors.primary,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Secondary navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              text: 'Profile',
                              onPressed: () => context.push('/profile'),
                              backgroundColor: AppColors.surfaceElevated,
                              textColor: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomElevatedButton(
                              text: 'Progress',
                              onPressed: () => context.push('/progress'),
                              backgroundColor: AppColors.surfaceElevated,
                              textColor: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const CustomText(
                        text: 'Explore the trail and enjoy the journey.',
                        style: AppTypography.body1,
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        CustomText(
          text: value,
          style: AppTypography.heading2.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 4),
        CustomText(
          text: label,
          style: AppTypography.body2,
        ),
      ],
    );
  }
}
