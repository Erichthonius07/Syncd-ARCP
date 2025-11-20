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
                    const Text("REQUESTS", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: friendService.friendRequests.isEmpty
                      ? Center(child: Text("NO PENDING INVITES", style: AppTheme.textTheme.labelSmall))
                      : ListView.builder(
                    itemCount: friendService.friendRequests.length,
                    itemBuilder: (context, index) {
                      final request = friendService.friendRequests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NeoCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.cyberYellow,
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.person_add),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(request.name, style: AppTheme.textTheme.bodyLarge),
                              ),
                              // Accept
                              GestureDetector(
                                onTap: () => friendService.acceptRequest(request),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.matrixGreen,
                                    border: Border.all(width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.check, size: 20),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Decline
                              GestureDetector(
                                onTap: () => friendService.declineRequest(request),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.hotPink,
                                    border: Border.all(width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.close, size: 20, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
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