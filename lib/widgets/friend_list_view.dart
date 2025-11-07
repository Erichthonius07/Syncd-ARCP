import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../screens/friend_detail_screen.dart';

class FriendListView extends StatelessWidget {
  final List<Friend> friends;
  const FriendListView({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 150),
                  reverseTransitionDuration: const Duration(milliseconds: 150),
                  pageBuilder: (_, __, ___) => FriendDetailScreen(friend: friend),
                ),
              );
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.onSurface.withAlpha(128),
                  width: 2,
                ),
              ),
              child: Hero(
                tag: friend.name,
                child: Icon(
                  friend.avatar,
                  color: theme.colorScheme.onSurface,
                  size: 30,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}