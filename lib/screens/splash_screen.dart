import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  double _glitchOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Trigger the glitch effect shortly after the screen loads
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        Random random = Random();
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (timer.tick > 5) {
            timer.cancel();
            setState(() {
              _glitchOffset = 0; // Reset position
              _isVisible = true; // Start the main fade-in animation
            });
          } else {
            setState(() {
              _glitchOffset = (random.nextDouble() - 0.5) * 15; // Increased glitch effect
            });
          }
        });
      }
    });

    _navigateToHome();
  }

  _navigateToHome() async {
    // Navigate after 4 seconds total
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: _isVisible ? 1.0 : 0.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your app icon with the glitch effect applied
              Transform.translate(
                offset: Offset(_glitchOffset, 0),
                child: Icon(
                  Icons.gamepad_outlined,
                  size: 100,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 20),
              // Your app name text
              Text(
                "Sync’d",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}