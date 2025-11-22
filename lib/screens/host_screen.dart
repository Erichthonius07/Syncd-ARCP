import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    Text("LOBBY", style: Theme.of(context).textTheme.displayLarge),
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
                          Text("GAME CODE", style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black)),
                          const SizedBox(height: 8),
                          Text(
                            gameCode,
                            style: GoogleFonts.spaceGrotesk(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.black),
                          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 8),

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
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Text("TAP TO COPY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Text("SQUAD (${players.length}/4)", style: Theme.of(context).textTheme.displaySmall),
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
                          color: isOccupied ? Theme.of(context).cardColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isOccupied ? Icons.person : Icons.add, size: 32, color: Theme.of(context).iconTheme.color),
                            const SizedBox(height: 8),
                            Text(name, style: TextStyle(fontFamily: 'Pixer', fontSize: 14, color: Theme.of(context).textTheme.bodyLarge!.color)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                NeoCard(
                  color: AppTheme.hotPink,
                  isButton: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Initializing Server...")));
                    Future.delayed(const Duration(seconds: 2), () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Game Started!")));
                      }
                    });
                  },
                  child: Center(
                    child: Text("START GAME", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white)),
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