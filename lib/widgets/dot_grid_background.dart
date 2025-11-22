import 'package:flutter/material.dart';

class DotGridBackground extends StatelessWidget {
  final Widget child;

  const DotGridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: GridPainter(context),
          ),
        ),
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
    final paint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.black.withValues(alpha: 0.05)
      ..strokeWidth = 2;

    const double spacing = 25.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}