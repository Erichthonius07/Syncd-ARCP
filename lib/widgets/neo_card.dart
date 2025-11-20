import 'package:flutter/material.dart';
import '../theme.dart';

class NeoCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double? height;
  final bool isButton; // If true, behaves like a physical arcade button

  const NeoCard({
    super.key,
    required this.child,
    this.onTap,
    this.color = Colors.white,
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
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50), // Snappy response
        height: widget.height,
        // Arcade Button Physics: Move down and to the right
        transform: _isPressed
            ? Matrix4.translationValues(AppTheme.shadowOffset, AppTheme.shadowOffset, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(12), // Slightly tighter corners for tech feel
          border: Border.all(color: AppTheme.border, width: AppTheme.borderWidth),
          boxShadow: _isPressed
              ? []
              : [
            const BoxShadow(
              color: AppTheme.border,
              offset: Offset(AppTheme.shadowOffset, AppTheme.shadowOffset),
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