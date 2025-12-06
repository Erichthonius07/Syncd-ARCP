import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class FriendsManagementScreen extends StatefulWidget {
  const FriendsManagementScreen({super.key});

  @override
  State<FriendsManagementScreen> createState() => _FriendsManagementScreenState();
}

class _FriendsManagementScreenState extends State<FriendsManagementScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    // Fetch the latest requests from the backend when the screen opens
    await Provider.of<FriendService>(context, listen: false).fetchRequests();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to the service for changes (like when a request is accepted/removed)
    final friendService = Provider.of<FriendService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final requests = friendService.friendRequests;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header ---
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, size: 32, color: Theme.of(context).iconTheme.color),
                    ),
                    const SizedBox(width: 16),
                    Text("INBOX", style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
                const SizedBox(height: 30),

                // --- Count Label ---
                Text(
                    "FRIEND REQUESTS (${requests.length})",
                    style: Theme.of(context).textTheme.labelSmall
                ),
                const SizedBox(height: 10),

                // --- List of Requests ---
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : requests.isEmpty
                      ? Center(
                    child: Text(
                        "No pending requests",
                        style: Theme.of(context).textTheme.bodyMedium
                    ),
                  )
                      : ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final request = requests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: NeoCard(
                          child: Row(
                            children: [
                              // Icon Container
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.cyberYellow,
                                  border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.mail, color: Colors.black),
                              ),
                              const SizedBox(width: 16),

                              // Username
                              Expanded(
                                  child: Text(
                                      request.name,
                                      style: Theme.of(context).textTheme.bodyLarge
                                  )
                              ),

                              // Accept Button
                              GestureDetector(
                                onTap: () async {
                                  await friendService.acceptRequest(request);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("You are now friends with ${request.name}!"),
                                          backgroundColor: Colors.green,
                                        )
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.matrixGreen,
                                    border: Border.all(width: 2, color: Theme.of(context).dividerColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.check, size: 20, color: Colors.black),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Decline Button
                              GestureDetector(
                                onTap: () async {
                                  await friendService.declineRequest(request);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Request declined"),
                                          backgroundColor: Colors.red,
                                        )
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppTheme.hotPink,
                                    border: Border.all(width: 2, color: Theme.of(context).dividerColor),
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