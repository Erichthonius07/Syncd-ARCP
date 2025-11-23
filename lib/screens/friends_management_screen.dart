import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class FriendsManagementScreen extends StatelessWidget {
  const FriendsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendService = Provider.of<FriendService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, size: 32, color: Theme.of(context).iconTheme.color)), const SizedBox(width: 16), Text("INBOX", style: Theme.of(context).textTheme.displayLarge)]),
                const SizedBox(height: 30),

                Text("FRIEND REQUESTS (${friendService.friendRequests.length})", style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 10),

                Expanded(
                  child: friendService.friendRequests.isEmpty
                      ? Center(child: Text("No pending requests", style: Theme.of(context).textTheme.bodyMedium))
                      : ListView.builder(
                    itemCount: friendService.friendRequests.length,
                    itemBuilder: (context, index) {
                      final request = friendService.friendRequests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NeoCard(
                          child: Row(children: [
                            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.cyberYellow, border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.mail, color: Colors.black)),
                            const SizedBox(width: 16),
                            Expanded(child: Text(request.name, style: Theme.of(context).textTheme.bodyLarge)),
                            GestureDetector(onTap: () => friendService.acceptRequest(request), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.matrixGreen, border: Border.all(width: 2, color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check, size: 20, color: Colors.black))),
                            const SizedBox(width: 8),
                            GestureDetector(onTap: () => friendService.declineRequest(request), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppTheme.hotPink, border: Border.all(width: 2, color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.close, size: 20, color: Colors.white))),
                          ]),
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