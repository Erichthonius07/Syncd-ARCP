import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme.dart';

class CyberLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const CyberLoader({
    super.key,
    this.size = 30,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    // REMOVED unused 'colors' variable
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Default to Electric Blue in Dark Mode for that "System Processing" look
    final activeColor = color ?? (isDark ? AppTheme.electricBlue : Colors.black);
    final outlineColor = isDark ? Colors.white.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.2);

    return SizedBox(
      height: size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return Container(
            width: size * 0.6,
            height: size,
            margin: EdgeInsets.symmetric(horizontal: size * 0.1),
            child: Animate(
              onPlay: (c) => c.repeat(), // Loop forever
              effects: [
                // Staggered Delay creates the "Wave"
                ShimmerEffect(
                  delay: Duration(milliseconds: index * 150),
                  duration: 1200.ms,
                  color: activeColor, // The flash color
                  size: 2.0, // Width of the shine
                ),
              ],
              child: _buildBlock(), // Helper for structure
            ),
          ).animate(
            onPlay: (c) => c.repeat(),
            delay: Duration(milliseconds: index * 150),
          ).custom(
            duration: 1200.ms,
            builder: (context, value, child) {
              // Logic: 0.0 -> 0.5 (Fill Up) -> 1.0 (Empty)
              final isActive = value > 0.2 && value < 0.6;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  // WIREFRAME VS SOLID LOGIC
                  color: isActive ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    // Border is always visible, but glows when active
                    color: isActive ? activeColor : outlineColor,
                    width: 2,
                  ),
                  boxShadow: (isDark && isActive) ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ] : [],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // Placeholder if we need complex block structure later
  Widget _buildBlock() {
    return Container();
  }
}