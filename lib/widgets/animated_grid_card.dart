import 'dart:math';
import 'package:flutter/material.dart'; // ✅ THE MISSING IMPORT

class AnimatedGridCard extends StatefulWidget {
  const AnimatedGridCard({super.key});

  @override
  State<AnimatedGridCard> createState() => _AnimatedGridCardState();
}

class _AnimatedGridCardState extends State<AnimatedGridCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(128),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: WarpingGridPainter(
                animationValue: _controller.value,
                color: theme.colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}

class WarpingGridPainter extends CustomPainter {
  final double animationValue;
  final Color color;

  WarpingGridPainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(128) // 50% opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const int horizontalCount = 20;
    const int verticalCount = 10;

    final double horizontalStep = size.width / horizontalCount;
    final double verticalStep = size.height / verticalCount;

    final path = Path();

    // Draw horizontal lines that are warped by the sine wave
    for (int j = 0; j <= verticalCount; j++) {
      path.moveTo(0, j * verticalStep);
      for (int i = 0; i <= horizontalCount; i++) {
        final double x = i * horizontalStep;
        final double y = j * verticalStep;
        final double wave =
            sin((x / size.width * 2 * pi) + (animationValue * 2 * pi)) * 10;
        path.lineTo(x, y + wave);
      }
    }

    // Draw vertical lines
    for (int i = 0; i <= horizontalCount; i++) {
      final double x = i * horizontalStep;
      path.moveTo(x, 0);
      path.lineTo(x, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}