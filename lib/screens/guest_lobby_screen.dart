import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class GuestLobbyScreen extends StatelessWidget {
  final String lobbyCode;

  const GuestLobbyScreen({super.key, required this.lobbyCode});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);
    // Mock Roster for the guest view
    final players = ["Host_X", "You", "Alex_99", "Waiting..."];

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("STATUS", style: Theme.of(context).textTheme.labelSmall),
                        Text("CONNECTED", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: colors.success)),
                      ],
                    ),
                    // Leave Button
                    NeoCard(
                      onTap: () => Navigator.pop(context),
                      color: AppTheme.hotPink,
                      child: const Icon(Icons.logout, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // INFO CARD
                Center(
                  child: NeoCard(
                    color: colors.surface,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Text("LOBBY ID", style: Theme.of(context).textTheme.labelSmall),
                          const SizedBox(height: 8),
                          Text(
                            lobbyCode,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 16),
                          const CircularProgressIndicator().animate().fadeIn(),
                          const SizedBox(height: 16),
                          Text(
                            "Waiting for Host to start...",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 1000.ms),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Text("SQUAD ROSTER", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 16),

                // ROSTER GRID (Read Only)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final isOccupied = index < players.length;
                      final name = isOccupied ? players[index] : "EMPTY";
                      final isMe = name == "You";

                      return NeoCard(
                        color: isMe ? colors.actionJoin : colors.surface,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                                isOccupied ? Icons.person : Icons.hourglass_empty,
                                size: 32,
                                color: isMe ? Colors.black : Theme.of(context).iconTheme.color
                            ),
                            const SizedBox(height: 8),
                            Text(
                                name,
                                style: TextStyle(
                                    fontFamily: 'Pixer',
                                    fontSize: 14,
                                    color: isMe ? Colors.black : Theme.of(context).textTheme.bodyLarge!.color
                                )
                            ),
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