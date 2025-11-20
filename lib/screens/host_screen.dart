import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added for Clipboard
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class HostScreen extends StatelessWidget {
  const HostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const gameCode = "SYNC-882";
    final players = ["You", "Alex", "Waiting..."];

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Text("LOBBY", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                  ],
                ),
                const SizedBox(height: 30),

                Center(
                  child: NeoCard(
                    color: AppTheme.electricBlue,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text("GAME CODE", style: AppTheme.textTheme.labelSmall),
                          const SizedBox(height: 8),
                          Text(
                            gameCode,
                            style: GoogleFonts.spaceGrotesk(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 2),
                          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 8),

                          // COPY BUTTON
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: gameCode));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Code Copied!")));
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(),
                              ),
                              child: const Text("TAP TO COPY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Text("SQUAD (${players.length}/4)", style: AppTheme.textTheme.displaySmall),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 1.3),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final isOccupied = index < players.length;
                      final name = isOccupied ? players[index] : "EMPTY";
                      return Container(
                        decoration: BoxDecoration(
                          color: isOccupied ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 2, color: isOccupied ? Colors.black : Colors.black26),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isOccupied ? Icons.person : Icons.add, color: isOccupied ? Colors.black : Colors.black26, size: 32),
                            const SizedBox(height: 8),
                            Text(name, style: TextStyle(fontFamily: 'Pixer', fontSize: 14, color: isOccupied ? Colors.black : Colors.black26)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // START BUTTON FIX
                NeoCard(
                  color: AppTheme.hotPink,
                  isButton: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Initializing Server...")));
                    Future.delayed(const Duration(seconds: 2), () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Game Started!")));
                    });
                  },
                  child: Center(
                    child: Text("START GAME", style: AppTheme.textTheme.displayMedium!.copyWith(color: Colors.white)),
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