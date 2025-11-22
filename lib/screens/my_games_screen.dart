import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class MyGamesScreen extends StatefulWidget {
  const MyGamesScreen({super.key});

  @override
  State<MyGamesScreen> createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  List<String> myGames = ["Cyber Racer", "Space Tanks"];
  List<String> availableGames = ["Pixel Arena", "Dungeon Drop", "Galaxy Golf"];

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("MY GAMES", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                const Text("INSTALLED", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
                const SizedBox(height: 16),
                _buildGameGrid(myGames, isInstalled: true),

                const SizedBox(height: 30),
                const Text("STORE", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
                const SizedBox(height: 16),
                _buildGameGrid(availableGames, isInstalled: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid(List<String> games, {required bool isInstalled}) {
    if (games.isEmpty) {
      return NeoCard(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: const Text("No games found.", textAlign: TextAlign.center),
        ),
      );
    }

    return Expanded(
      flex: isInstalled ? 3 : 2,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.0
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return NeoCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.videogame_asset, size: 40, color: isInstalled ? AppTheme.electricBlue : Colors.grey),
                const SizedBox(height: 8),
                Text(game, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isInstalled) {
                        myGames.remove(game);
                        availableGames.add(game);
                      } else {
                        availableGames.remove(game);
                        myGames.add(game);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isInstalled ? AppTheme.hotPink : AppTheme.matrixGreen,
                      shape: BoxShape.circle,
                      border: Border.all(width: 2),
                    ),
                    child: Icon(isInstalled ? Icons.delete : Icons.download, size: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}