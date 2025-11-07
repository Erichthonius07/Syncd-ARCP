import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/app_background.dart';
import '../widgets/pulsing_button.dart';
import 'host_screen.dart';
import 'join_screen.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;
  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(game.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AppBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Hero(
                  tag: 'game_icon_${game.name}',
                  child: Icon(
                    game.icon,
                    size: 100,
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  game.name,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Ready to play? Host or join a session!",
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JoinScreen(),
                              ),
                            );
                          },
                          child: const Text("Join"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: PulsingButton(
                          text: "Host",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HostScreen(game: game),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}