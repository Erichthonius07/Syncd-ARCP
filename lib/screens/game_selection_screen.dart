import 'package:flutter/material.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';
import 'host_screen.dart';

class GameSelectionScreen extends StatelessWidget {
  const GameSelectionScreen({super.key});

  final List<String> games = const ["Cyber Racer", "Space Tanks", "Pixel Arena", "Dungeon Drop"];

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
                    const Text("PICK GAME", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9, // Taller for cartridge look
                    ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      return NeoCard(
                        color: Colors.white,
                        isButton: true,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const HostScreen()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Cartridge Art Placeholder
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: index % 2 == 0 ? AppTheme.electricBlue : AppTheme.cyberYellow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(width: 2),
                              ),
                              child: Icon(Icons.videogame_asset, size: 40, color: Colors.black.withValues(alpha: 0.5)),
                            ),
                            const SizedBox(height: 16),
                            Text(games[index], style: AppTheme.textTheme.bodyLarge!.copyWith(fontSize: 16), textAlign: TextAlign.center),
                          ],
                        ),
                      );
                    },
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