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
                Text("DETAILS", style: Theme.of(context).textTheme.labelSmall),
                Text(gameName.toUpperCase(), style: Theme.of(context).textTheme.displayLarge),

                const SizedBox(height: 40),

                NeoCard(
                  color: AppTheme.cyberYellow,
                  isButton: true,
                  onTap: () => Navigator.pushNamed(context, '/host'),
                  child: const Center(
                    child: Text("HOST GAME", style: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Colors.black)),
                  ),
                ),

                const SizedBox(height: 16),

                NeoCard(
                  color: Theme.of(context).cardColor,
                  isButton: true,
                  onTap: () => Navigator.pushNamed(context, '/join'),
                  child: Center(
                    child: Text("JOIN LOBBY", style: TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Theme.of(context).textTheme.bodyLarge!.color)),
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