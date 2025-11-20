import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/dot_grid_background.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login'); // Changed to Login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cyberYellow,
                  border: Border.all(width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
                ),
                child: const Text(
                  "SYNC'D",
                  style: TextStyle(fontFamily: 'Pixer', fontSize: 48, color: Colors.black),
                ),
              ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),

              const SizedBox(height: 30),

              const Text("INITIALIZING...", style: TextStyle(fontFamily: 'Pixer', fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}