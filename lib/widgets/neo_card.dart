import 'package:flutter/material.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final accentColor = widget.color ?? colors.surface;
    final isSurfaceCard = widget.color == null || widget.color == colors.surface;

    Color finalBgColor;
    Color finalBorderColor;
    Color finalContentColor;
    Color finalShadowColor;
    double finalBlur;

    if (isDark) {
      // DARK MODE
      if (!isSurfaceCard) {
        // Colored Button -> Black BG, Neon Text/Border
        finalBgColor = Colors.black;
        finalBorderColor = accentColor;
        finalContentColor = accentColor;
        finalShadowColor = accentColor.withValues(alpha: 0.6);
        finalBlur = 15.0;
      } else {
        // Surface Card -> Dark Grey BG
        finalBgColor = const Color(0xFF121212);
        finalBorderColor = const Color(0xFF333333);
        finalContentColor = Colors.white;
        finalShadowColor = Colors.black;
        finalBlur = 0.0;
      }
    } else {
      // LIGHT MODE
      finalBgColor = accentColor;
      finalBorderColor = Colors.black;
      finalContentColor = Colors.black;
      finalShadowColor = Colors.black;
      finalBlur = 0.0;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
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
          color: finalBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: finalBorderColor, width: AppTheme.borderWidth),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: finalShadowColor,
              offset: isDark && !isSurfaceCard
                  ? const Offset(0, 0)
                  : const Offset(AppTheme.shadowOffset, AppTheme.shadowOffset),
              blurRadius: finalBlur,
              spreadRadius: isDark && !isSurfaceCard ? 1 : 0,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: IconThemeData(color: finalContentColor),
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: finalContentColor,
                displayColor: finalContentColor,
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}