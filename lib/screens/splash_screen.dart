import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/cyber_loader.dart'; // Updated Loader
import '../services/auth_service.dart';
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
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Visual delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Since we removed Secure Storage, this will always return false for now,
    // sending you to the Login Screen (which is what we want for development).
    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = await authService.checkLoginStatus();

    if (mounted) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
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

              const SizedBox(height: 40),

              // The New "Loading Bar" Style Loader
              const CyberLoader(size: 30, color: AppTheme.electricBlue),

              const SizedBox(height: 20),
              const Text("INITIALIZING...", style: TextStyle(fontFamily: 'Pixer', fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}