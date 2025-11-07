import 'package:flutter/material.dart'; // ✅ THE MISSING IMPORT
import '../models/friend_model.dart';

class FriendDetailScreen extends StatelessWidget {
  final Friend friend;

  const FriendDetailScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(friend.name),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            color: Colors.black.withAlpha(51),
            child: Center(
              child: Hero(
                tag: friend.name,
                child: Icon(
                  friend.avatar,
                  size: 100,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      "Online",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            // ... inside the build method ...
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement chat logic
                      },
                      child: const Text("Start Chat"),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement game invite logic
                      },
                      // ✅ UPDATED TEXT
                      child: const Text("Invite"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}