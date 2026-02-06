import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_state.dart';
import '../../bloc/profile_event.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/custom_popup.dart';
import '../../widgets/custom_text.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';

/// Profile screen displaying user profile information with real data
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Reload profile data when opening profile screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(const LoadProfile());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showEditNamePopup(BuildContext context, String currentName) {
    _nameController.text = currentName;
    
    CustomPopup.show(
      context,
      CustomPopup(
        title: 'Edit Name',
        content: TextField(
          controller: _nameController,
          style: AppTypography.body1,
          decoration: InputDecoration(
            hintText: 'Enter your name',
            hintStyle: AppTypography.body2,
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                context.read<ProfileBloc>().add(
                  UpdatePlayerName(_nameController.text),
                );
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    CustomPopup.show(
      context,
      CustomPopup(
        title: 'Reset All Data?',
        content: const CustomText(
          text: 'This will delete all your progress, stats, and achievements. This action cannot be undone!',
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProfileBloc>().add(const ResetAllData());
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
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
              child: CustomText(text: 'No profile data'),
            );
          }

          final profile = state.profile!;

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: CustomText(
                    text: 'Profile',
                    style: AppTypography.heading2,
                  ),
                  centerTitle: true,
                ),
              ),
              
              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Name Card
                      CardWidget(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                    text: 'Player Name',
                                    style: AppTypography.body2,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: profile.playerName,
                                    style: AppTypography.heading2.copyWith(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _showEditNamePopup(
                                context,
                                profile.playerName,
                              ),
                              icon: const Icon(
                                Icons.edit,
                                color: AppColors.primary,
                              ),
                              tooltip: 'Edit name',
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Level Card
                      CardWidget(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  text: 'Level',
                                  style: AppTypography.body1,
                                ),
                                CustomText(
                                  text: '${profile.level}',
                                  style: AppTypography.heading1.copyWith(
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: profile.levelProgress,
                                minHeight: 12,
                                backgroundColor: AppColors.surface,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              text: '${(profile.levelProgress * 100).toInt()}% to next level',
                              style: AppTypography.body2,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Stats Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.videogame_asset,
                              label: 'Games',
                              value: '${profile.totalGamesPlayed}',
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.star,
                              label: 'High Score',
                              value: '${profile.highestScore}',
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.trending_up,
                              label: 'Total Score',
                              value: '${profile.totalScore}',
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              icon: Icons.local_fire_department,
                              label: 'Best Combo',
                              value: '${profile.longestCombo}x',
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Accuracy Card
                      CardWidget(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomText(
                                  text: 'Overall Accuracy',
                                  style: AppTypography.body1,
                                ),
                                CustomText(
                                  text: '${profile.overallAccuracy.toStringAsFixed(1)}%',
                                  style: AppTypography.heading2.copyWith(
                                    color: _getAccuracyColor(profile.overallAccuracy),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildHitRow('Perfect', profile.totalPerfectHits, AppColors.warning),
                            const SizedBox(height: 8),
                            _buildHitRow('Good', profile.totalGoodHits, AppColors.success),
                            const SizedBox(height: 8),
                            _buildHitRow('OK', profile.totalOkHits, AppColors.primary),
                            const SizedBox(height: 8),
                            _buildHitRow('Miss', profile.totalMisses, AppColors.error),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Reset Button
                      ElevatedButton.icon(
                        onPressed: () => _showResetConfirmation(context),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset All Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return CardWidget(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          CustomText(
            text: value,
            style: AppTypography.heading2,
          ),
          const SizedBox(height: 4),
          CustomText(
            text: label,
            style: AppTypography.body2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHitRow(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            CustomText(
              text: label,
              style: AppTypography.body1,
            ),
          ],
        ),
        CustomText(
          text: '$count',
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) return AppColors.success;
    if (accuracy >= 75) return AppColors.primary;
    if (accuracy >= 60) return AppColors.warning;
    return AppColors.error;
  }
}
