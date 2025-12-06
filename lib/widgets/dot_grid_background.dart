import 'package:flutter/material.dart';
import '../theme.dart';

class DotGridBackground extends StatelessWidget {
  final Widget child;

  const DotGridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Base Background
        Positioned.fill(
          child: Container(color: Theme.of(context).scaffoldBackgroundColor),
        ),

        // 2. Grid Painter
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(context),
          ),
        ),

        // 3. Content
        child,
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final BuildContext context;
  GridPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = AppTheme.c(context);

    final paint = Paint()
      ..color = isDark
          ? colors.outline.withValues(alpha: 0.15) // Subtle Cyber Lines
          : Colors.black.withValues(alpha: 0.05)   // Subtle Paper Dots
      ..strokeWidth = 2;

    const double spacing = 30.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        if (isDark) {
          // Crosshairs (+) for Dark Mode
          canvas.drawLine(Offset(x - 3, y), Offset(x + 3, y), paint);
          canvas.drawLine(Offset(x, y - 3), Offset(x, y + 3), paint);
        } else {
          // Dots (.) for Light Mode
          canvas.drawCircle(Offset(x, y), 1.5, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}