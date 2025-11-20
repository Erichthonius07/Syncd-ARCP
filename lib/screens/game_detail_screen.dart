import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class GameDetailScreen extends StatelessWidget {
  final String gameName;

  const GameDetailScreen({super.key, this.gameName = "Unknown Game"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, size: 32),
                ),
                const SizedBox(height: 20),
                Text("DETAILS", style: AppTheme.textTheme.labelSmall),
                Text(gameName.toUpperCase(), style: AppTheme.textTheme.displayLarge),

                const SizedBox(height: 40),

                // Host Button
                NeoCard(
                  color: AppTheme.cyberYellow,
                  isButton: true,
                  onTap: () => Navigator.pushNamed(context, '/host'),
                  child: const Center(
                    child: Text("HOST GAME", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
                  ),
                ),

                const SizedBox(height: 16),

                // Join Button
                NeoCard(
                  color: Colors.white,
                  isButton: true,
                  onTap: () => Navigator.pushNamed(context, '/join'),
                  child: const Center(
                    child: Text("JOIN LOBBY", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
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