import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_model.dart';
import '../services/friend_service.dart';

class HostScreen extends StatelessWidget {
  final Game game;
  const HostScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final friends = Provider.of<FriendService>(context).friends;

    return Scaffold(
      appBar: AppBar(
        title: Text('Host: ${game.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(game.icon, size: 40, color: theme.colorScheme.secondary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Lobby for ${game.name}',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            const Divider(height: 40, color: Colors.white24),
            Text(
              'Invite Friends',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  return Card(
                    color: Colors.black.withAlpha(51),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Icon(friend.avatar, color: theme.colorScheme.primary),
                      title: Text(
                        friend.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {},
                        child: const Text('Invite'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}