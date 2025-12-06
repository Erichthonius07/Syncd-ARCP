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
  List<String> myGames = ["Cyber Racer", "Space Tanks", "Doom", "Halo"];
  List<String> availableGames = ["Pixel Arena", "Dungeon Drop", "Galaxy Golf", "Poker", "Chess"];

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);

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
                    const Text("LIBRARY", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                const Text("INSTALLED", style: TextStyle(fontFamily: 'Pixer', fontSize: 20)),
                const SizedBox(height: 12),
                _buildGameGrid(myGames, isInstalled: true, colors: colors),

                const SizedBox(height: 24),
                const Text("ON DEVICE", style: TextStyle(fontFamily: 'Pixer', fontSize: 20)),
                const SizedBox(height: 12),
                _buildGameGrid(availableGames, isInstalled: false, colors: colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameGrid(List<String> games, {required bool isInstalled, required SyncPalette colors}) {
    if (games.isEmpty) {
      return NeoCard(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: const Text("No games found.", textAlign: TextAlign.center)
          )
      );
    }

    return Expanded(
      flex: isInstalled ? 3 : 2,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          // --- FINAL POLISH: 4 Columns ---
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85 // Slightly tall for Icon + Text
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return NeoCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Smaller Icon for dense grid
                Icon(
                    Icons.videogame_asset,
                    size: 28,
                    color: isInstalled ? colors.actionLibrary : Colors.grey
                ),
                const SizedBox(height: 4),

                // Smaller, safe text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Text(
                      game,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontFamily: 'Pixer', // Use pixel font for retro feel
                          fontSize: 10,        // Small enough for 4-col
                          color: colors.textMain
                      )
                  ),
                ),
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
                    padding: const EdgeInsets.all(4), // Smaller touch target padding
                    decoration: BoxDecoration(
                      color: isInstalled ? AppTheme.hotPink : AppTheme.matrixGreen,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5),
                    ),
                    child: Icon(
                        isInstalled ? Icons.remove : Icons.add,
                        size: 12,
                        color: Colors.white
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          );
        },
      ),
    );
  }
}