import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/app_colors.dart';

/// Modal dialog: dark surface, brand typography.
class CustomPopup extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;

  const CustomPopup({
    super.key,
    required this.title,
    required this.content,
    this.actions,
  });

  static Future<T?> show<T>(BuildContext context, CustomPopup popup) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => popup,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            content,
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((a) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: a,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
