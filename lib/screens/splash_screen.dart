import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/socket_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/cyber_loader.dart'; // Make sure you have this widget!
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
    // 1. Visual delay for the splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 2. Check for stored auth token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (mounted) {
      if (token != null) {
        // --- LOGGED IN ---
        print("✅ Token found. Connecting socket...");

        // Connect WebSocket with the stored token
        Provider.of<SocketService>(context, listen: false).connect(token);

        // Navigate to Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // --- NOT LOGGED IN ---
        print("❌ No token found. Going to Login.");
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cyberYellow, // Fallback color
      body: DotGridBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- Logo with Animation ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.cyberYellow,
                  border: Border.all(width: 4),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6), blurRadius: 0)],
                ),
                child: const Text(
                  "SYNC'D",
                  style: TextStyle(
                    fontFamily: 'Pixer',
                    fontSize: 48,
                    color: Colors.black,
                  ),
                ),
              ).animate().scale(
                  curve: Curves.elasticOut,
                  duration: 800.ms,
                  begin: const Offset(0.5, 0.5)
              ),

              const SizedBox(height: 40),

              // --- Custom Loader ---
              // If CyberLoader isn't working, replace this line with:
              // const CircularProgressIndicator(color: Colors.black),
              const CyberLoader(size: 30, color: AppTheme.electricBlue),

              const SizedBox(height: 20),

              // --- Status Text ---
              const Text(
                  "INITIALIZING...",
                  style: TextStyle(
                      fontFamily: 'Pixer',
                      fontSize: 14,
                      color: Colors.black54
                  )
              ).animate()
                  .fadeIn(delay: 500.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}