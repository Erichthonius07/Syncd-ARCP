import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../widgets/add_friend_dialog.dart';

class FriendsManagementScreen extends StatelessWidget {
  const FriendsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use 'watch' to make the UI rebuild when the data changes
    final friendService = context.watch<FriendService>();
    final friends = friendService.friends;
    final requests = friendService.friendRequests;

    return DefaultTabController(
      length: 2, // Two tabs: "All Friends" and "Requests"
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Friends'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'All Friends'),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Requests'),
                    if (requests.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.secondary,
                        radius: 12,
                        child: Text(
                          requests.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // "All Friends" Tab
            ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  leading: Icon(friend.avatar, color: theme.colorScheme.primary),
                  title: Text(friend.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Online', style: TextStyle(color: theme.colorScheme.primary)),
                  trailing: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
                );
              },
            ),
            // "Requests" Tab
            ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return ListTile(
                  leading: const Icon(Icons.person, color: Colors.white70),
                  title: Text(request.name, style: const TextStyle(color: Colors.white)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => friendService.acceptRequest(request),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => friendService.declineRequest(request),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddFriendDialog(friendService: friendService),
            );
          },
          child: const Icon(Icons.person_add_alt_1),
        ),
      ),
    );
  }
}