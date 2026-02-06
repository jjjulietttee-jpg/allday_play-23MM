import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/card_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Tutorial screen explaining how to play the rhythm game
class GameTutorialScreen extends StatelessWidget {
  const GameTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon:
                    const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: const FlexibleSpaceBar(
                title: CustomText(
                  text: 'How to Play',
                  style: AppTypography.heading2,
                ),
                centerTitle: true,
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Game Description
                    CardWidget(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.music_note,
                                color: AppColors.primary,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              const CustomText(
                                text: 'Tap Rhythm Trail',
                                style: AppTypography.heading2,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const CustomText(
                            text:
                                'Test your rhythm and reflexes! Tap the notes as they reach the glowing line at the bottom. Build combos for higher scores and try to beat your best!',
                            style: AppTypography.body1,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // How to Play
                    const CustomText(
                      text: '🎮 How to Play',
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 12),

                    _buildInstructionCard(
                      icon: Icons.touch_app,
                      color: AppColors.primary,
                      title: 'Tap the Lane',
                      description:
                          'When a note reaches the white line, tap anywhere on that lane to hit it.',
                    ),

                    const SizedBox(height: 12),

                    _buildInstructionCard(
                      icon: Icons.timer,
                      color: AppColors.accent,
                      title: 'Perfect Timing',
                      description:
                          'The closer to the line you tap, the more points you get. Aim for Perfect hits!',
                    ),

                    const SizedBox(height: 12),

                    _buildInstructionCard(
                      icon: Icons.trending_up,
                      color: AppColors.success,
                      title: 'Build Combos',
                      description:
                          'Hit notes consecutively to build a combo multiplier and boost your score.',
                    ),

                    const SizedBox(height: 12),

                    _buildInstructionCard(
                      icon: Icons.speed,
                      color: AppColors.warning,
                      title: 'Increasing Speed',
                      description:
                          'The game gets faster over time. Stay focused and keep the rhythm!',
                    ),

                    const SizedBox(height: 20),

                    // Scoring System
                    const CustomText(
                      text: '⭐ Scoring System',
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 12),

                    CardWidget(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildScoreRow('Perfect', '+100 pts + Combo Bonus',
                              AppColors.warning),
                          const Divider(height: 24),
                          _buildScoreRow('Good', '+50 pts + Combo Bonus',
                              AppColors.success),
                          const Divider(height: 24),
                          _buildScoreRow(
                              'OK', '+25 pts (Combo Reset)', AppColors.primary),
                          const Divider(height: 24),
                          _buildScoreRow(
                              'Miss', '0 pts (Combo Reset)', AppColors.error),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Game Over
                    CardWidget(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: AppColors.error.withValues(alpha: 0.2),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber,
                            color: AppColors.error,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: CustomText(
                              text:
                                  'Game Over after 10 missed notes!\nStay focused and don\'t let notes pass!',
                              style: AppTypography.body1,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tips
                    const CustomText(
                      text: '💡 Pro Tips',
                      style: AppTypography.heading2,
                    ),
                    const SizedBox(height: 12),

                    CardWidget(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTipRow('Watch the rhythm pattern'),
                          const SizedBox(height: 12),
                          _buildTipRow('Don\'t tap too early or too late'),
                          const SizedBox(height: 12),
                          _buildTipRow('Focus on one lane at a time'),
                          const SizedBox(height: 12),
                          _buildTipRow(
                              'Use the pause button if you need a break'),
                          const SizedBox(height: 12),
                          _buildTipRow('Practice makes perfect!'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Start Button
                    CustomElevatedButton(
                      text: 'Start',
                      onPressed: () => context.go('/game'),
                      backgroundColor: AppColors.primary,
                    ),

                    const SizedBox(height: 16),

                    // Back Button
                    CustomElevatedButton(
                      text: 'Back to Menu',
                      onPressed: () => context.pop(),
                      backgroundColor: AppColors.surface,
                      textColor: AppColors.textPrimary,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return CardWidget(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  style: AppTypography.body1.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: description,
                  style: AppTypography.body2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String label, String points, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: label,
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        CustomText(
          text: points,
          style: AppTypography.body2,
        ),
      ],
    );
  }

  Widget _buildTipRow(String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: '• ',
          style: AppTypography.body1,
        ),
        Expanded(
          child: CustomText(
            text: tip,
            style: AppTypography.body1,
          ),
        ),
      ],
    );
  }
}
