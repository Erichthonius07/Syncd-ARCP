import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cyberYellow,
                    border: Border.all(width: 4),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                  ),
                  child: const Text(
                    "SYNC'D",
                    style: TextStyle(fontFamily: 'Pixer', fontSize: 48, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 40),

                // Inputs
                const NeoCard(
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "USERNAME",
                      border: InputBorder.none,
                      icon: Icon(Icons.person),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const NeoCard(
                  color: Colors.white,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "PASSWORD",
                      border: InputBorder.none,
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Login Button
                NeoCard(
                  color: AppTheme.hotPink,
                  isButton: true,
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: const Center(
                    child: Text("PRESS START", style: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}