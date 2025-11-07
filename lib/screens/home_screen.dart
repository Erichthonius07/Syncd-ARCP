import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_icons.dart';
import '../services/friend_service.dart';
import '../services/game_service.dart';
import '../widgets/app_background.dart';
import '../widgets/friend_list_view.dart';
import '../widgets/game_list_view.dart';
import 'activity_screen.dart';
import 'friends_management_screen.dart';
import 'menu_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showScreenAsDialog(BuildContext context, Widget screen) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Screen Dialog',
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return screen;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppBackground(),
          const HomeTab(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  // Menu Button (Top Left)
                  IconButton(
                    icon: const Icon(AppIcons.gamepad, size: 28),
                    onPressed: () => _showScreenAsDialog(context, const MenuScreen()),
                  ),
                  // ✅ ADD the "SYNC'D" title in the middle
                  Expanded(
                    child: Text(
                      "SYNC'D",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 24,
                        fontFamily: 'Pixer',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Activity Button (Top Right)
                  IconButton(
                    icon: const Icon(AppIcons.flash, size: 28),
                    onPressed: () => _showScreenAsDialog(context, const ActivityScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final gameService = Provider.of<GameService>(context);
    final friendService = Provider.of<FriendService>(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Text(
              "MY GAMES",
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontSize: 18, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 15),
            GameListView(games: gameService.games),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "FRIENDS",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontSize: 18, color: theme.colorScheme.onSurface),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FriendsManagementScreen(),
                      ),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 15),
            FriendListView(friends: friendService.friends),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}