import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/user_repository.dart';
import '../../widgets/custom_text.dart';

/// Splash screen: animated logo/title (2 sec), then navigates to onboarding or menu.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scale = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _mainController.forward();

    Future<void>.delayed(const Duration(milliseconds: 2100), _navigateAway);
  }

  Future<void> _navigateAway() async {
    if (!mounted) return;
    final repo = context.read<UserRepository>();
    final completed = await repo.isOnboardingCompleted();
    if (!mounted) return;
    if (completed) {
      context.go('/menu');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.background.withValues(alpha: 0.4),
                AppColors.background.withValues(alpha: 0.85),
                AppColors.background,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo / icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 24,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_circle_fill,
                              size: 56,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 28),
                          CustomText(
                            text: 'AllDay Play',
                            style: AppTypography.heading1.copyWith(
                              fontSize: 36,
                              color: AppColors.textPrimary,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: 'Play anytime',
                            style: AppTypography.body2.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
