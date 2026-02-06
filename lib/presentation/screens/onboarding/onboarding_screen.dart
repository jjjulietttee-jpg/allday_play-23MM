import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/user_repository.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_colors.dart';

/// Onboarding screen with a 3-page PageView flow.
/// 
/// Features:
/// - PageView with 3 pages showing app introduction
/// - Each page has an icon, title, and description
/// - Progress indicators (3 dots) showing current page
/// - Skip button (top-right) to jump to menu
/// - Start/Next button (bottom) to advance or complete onboarding
/// - Uses Column and Expanded layout (NO Sliver widgets)
/// 
/// Satisfies Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _navigateToMenu() async {
    await context.read<UserRepository>().setOnboardingCompleted();
    if (!mounted) return;
    context.go('/menu');
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        children: [
          // Skip button (top-right)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToMenu,
                child: const CustomText(
                  text: 'Skip',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          // PageView with 3 pages
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                _buildPage(
                  icon: Icons.explore,
                  title: 'Welcome to the Adventure!',
                  description: 'Embark on an exciting journey filled with fun challenges and discoveries.',
                ),
                _buildPage(
                  icon: Icons.star,
                  title: 'Track Your Progress',
                  description: 'Watch yourself grow as you complete challenges and unlock achievements.',
                ),
                _buildPage(
                  icon: Icons.celebration,
                  title: 'Ready to Start?',
                  description: 'Let\'s begin your adventure together. The fun awaits!',
                ),
              ],
            ),
          ),
          
          // Progress indicators (3 dots)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => _buildProgressDot(index),
              ),
            ),
          ),
          
          // Start/Next button (bottom)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomElevatedButton(
              text: _currentPage == 2 ? 'Start' : 'Next',
              onPressed: _nextPage,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single onboarding page with icon, title, and description
  Widget _buildPage({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 120,
            color: AppColors.primary,
          ),
          const SizedBox(height: 48),
          CustomText(
            text: title,
            style: AppTypography.heading1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          CustomText(
            text: description,
            style: AppTypography.body1.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 6,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  /// Builds a single progress indicator dot
  Widget _buildProgressDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
