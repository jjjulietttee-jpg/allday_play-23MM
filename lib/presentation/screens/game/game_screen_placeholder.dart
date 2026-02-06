import 'package:flutter/material.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_text.dart';

/// Game screen placeholder - minimal implementation for Task 10
/// 
/// This is a placeholder route for future game implementation.
/// The game mechanics will be implemented in later stages.
/// 
/// Requirements: 7.6, 11.6
class GameScreenPlaceholder extends StatelessWidget {
  const GameScreenPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Center(
        child: CustomText(
          text: 'Game Coming Soon!',
        ),
      ),
    );
  }
}
