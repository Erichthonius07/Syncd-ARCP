import 'dart:ui';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withAlpha(50),
            theme.scaffoldBackgroundColor,
            theme.colorScheme.secondary.withAlpha(50),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: Colors.black.withAlpha(25),
        ),
      ),
    );
  }
}