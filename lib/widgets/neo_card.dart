import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class NeoCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final double? height;
  final bool isButton;

  const NeoCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.height,
    this.isButton = false,
  });

  @override
  State<NeoCard> createState() => _NeoCardState();
}

class _NeoCardState extends State<NeoCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);

    // Always Light Mode Colors now
    final bgColor = widget.color ?? colors.surface;
    final borderColor = colors.outline;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap != null) HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        height: widget.height,
        transform: _isPressed
            ? Matrix4.translationValues(AppTheme.shadowOffset, AppTheme.shadowOffset, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: AppTheme.borderWidth),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: borderColor,
              offset: const Offset(AppTheme.shadowOffset, AppTheme.shadowOffset),
              blurRadius: 0,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: widget.child,
        ),
      ),
    );
  }
}