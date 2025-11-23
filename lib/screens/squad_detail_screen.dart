import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class SquadDetailScreen extends StatelessWidget {
  final Squad squad;

  const SquadDetailScreen({super.key, required this.squad});

  @override
  Widget build(BuildContext context) {
    final friendService = Provider.of<FriendService>(context);
    final isCreator = squad.creatorName == friendService.currentUserName;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // We need context to pop the dialog
    void confirmLeave() {
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          child: NeoCard(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                const Icon(Icons.warning_amber_rounded, size: 48, color: AppTheme.cyberYellow),
                const SizedBox(height: 16),

                Text(
                    isCreator ? "DISBAND SQUAD?" : "LEAVE SQUAD?",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.red)
                ),
                const SizedBox(height: 8),

                Text(
                  isCreator
                      ? "This will remove all members and delete the group."
                      : "You will need an invite to join back.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: NeoCard(
                        color: Theme.of(context).cardColor,
                        onTap: () => Navigator.pop(ctx),
                        child: Center(child: Text("CANCEL", style: Theme.of(context).textTheme.bodyLarge)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Confirm
                    Expanded(
                      child: NeoCard(
                        color: AppTheme.hotPink,
                        isButton: true,
                        onTap: () {
                          // 1. Perform Logic
                          friendService.leaveSquad(squad.id);
                          // 2. Close Dialog
                          Navigator.pop(ctx);
                          // 3. Close Screen (Go back to Home)
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("You left the squad."))
                          );
                        },
                        child: const Center(
                            child: Text("CONFIRM", style: TextStyle(fontFamily: 'Pixer', fontSize: 18, color: Colors.white))
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("MANAGE", style: Theme.of(context).textTheme.labelSmall),
                        Text(squad.name.toUpperCase(), style: Theme.of(context).textTheme.displayMedium),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Add Member Button (HIDDEN IF FULL)
                if (squad.memberNames.length < 4)
                  NeoCard(
                    color: AppTheme.matrixGreen,
                    isButton: true,
                    onTap: () => _showAddMemberDialog(context, friendService),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person_add_alt_1, color: Colors.black),
                        const SizedBox(width: 12),
                        Text("RECRUIT MEMBER", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),
                Text("ROSTER (${squad.memberNames.length}/4)", style: TextStyle(fontFamily: 'Pixer', fontSize: 18, color: Theme.of(context).textTheme.bodyLarge!.color)),
                const SizedBox(height: 10),

                // Roster List
                Expanded(
                  child: ListView.builder(
                    itemCount: squad.memberNames.length,
                    itemBuilder: (context, index) {
                      final member = squad.memberNames[index];
                      final isMe = member == friendService.currentUserName;
                      final isMemberCreator = member == squad.creatorName;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: NeoCard(
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: isMemberCreator ? AppTheme.cyberYellow : AppTheme.electricBlue,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
                                ),
                                child: Center(child: Text(member[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20))),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(member, style: Theme.of(context).textTheme.bodyLarge)),

                              // Kick Button
                              if (isCreator && !isMe)
                                GestureDetector(
                                  onTap: () {
                                    friendService.removeMember(squad.id, member);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kicked $member")));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.hotPink,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
                                    ),
                                    child: const Icon(Icons.gavel, size: 18, color: Colors.white),
                                  ),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Leave Button (Triggers Dialog)
                Center(
                  child: TextButton(
                    onPressed: confirmLeave, // Call the dialog function
                    child: Text(
                        isCreator ? "DISBAND SQUAD" : "LEAVE SQUAD",
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMemberDialog(BuildContext context, FriendService service) {
    // Same as before, just lists friends not in squad
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("ADD FRIEND", style: TextStyle(fontFamily: 'Pixer')),
        children: service.friends.where((f) => !squad.memberNames.contains(f.name)).map((f) => SimpleDialogOption(
          child: Text(f.name),
          onPressed: () {
            service.addMemberToSquad(squad.id, f.name);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added ${f.name}")));
          },
        )).toList(),
      ),
    );
  }
}