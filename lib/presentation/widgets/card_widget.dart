import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Card with dark surface and subtle border; optional tap animation.
class CardWidget extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CardWidget({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.onTap,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.surfaceElevated,
          width: 1,
        ),
      ),
      child: widget.child,
    );

    if (widget.onTap != null) {
      return GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: ScaleTransition(scale: _scale, child: content),
      );
    }
    return content;
  }
}
