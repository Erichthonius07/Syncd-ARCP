import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../screens/game_detail_screen.dart';

class GameListView extends StatelessWidget {
  final List<Game> games;
  const GameListView({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  reverseTransitionDuration: const Duration(milliseconds: 150),
                  pageBuilder: (_, __, ___) => GameDetailScreen(game: game),
                ),
              );
            },
            child: Container(
              width: 100,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withAlpha(128),
                ),
              ),
              child: Hero(
                tag: 'game_icon_${game.name}',
                child: Icon(
                  game.icon,
                  color: theme.colorScheme.onSurface,
                  size: 40,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}