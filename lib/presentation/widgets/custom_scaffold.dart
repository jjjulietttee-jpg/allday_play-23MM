import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Full-screen scaffold with background image and dark gradient overlay.
/// Brand style: dark base with accent gradient for readability.
class CustomScaffold extends StatelessWidget {
  final Widget body;
  final bool useSafeArea;

  const CustomScaffold({
    super.key,
    required this.body,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: useSafeArea ? SafeArea(child: body) : body,
        ),
      ),
    );
  }
}
