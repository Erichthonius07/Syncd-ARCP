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

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SQUAD", style: Theme.of(context).textTheme.labelSmall),
                        Text(squad.name.toUpperCase(), style: const TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                if (squad.memberNames.length < 4)
                  NeoCard(
                    color: AppTheme.matrixGreen,
                    isButton: true,
                    onTap: () => _showAddMemberDialog(context, friendService),
                    child: const Center(child: Text("ADD MEMBER +", style: TextStyle(fontFamily: 'Pixer', fontSize: 20))),
                  ),

                const SizedBox(height: 20),
                const Text("ROSTER", style: TextStyle(fontFamily: 'Pixer', fontSize: 18)),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: squad.memberNames.length,
                    itemBuilder: (context, index) {
                      final member = squad.memberNames[index];
                      final isMe = member == friendService.currentUserName;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: NeoCard(
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(color: AppTheme.cyberYellow, borderRadius: BorderRadius.circular(8), border: Border.all()),
                                child: Center(child: Text(member[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                              ),
                              const SizedBox(width: 16),
                              Text(member, style: Theme.of(context).textTheme.bodyLarge),
                              const Spacer(),
                              if (isCreator && !isMe)
                                GestureDetector(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kicked $member")));
                                  },
                                  child: const Icon(Icons.remove_circle, color: AppTheme.hotPink),
                                )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("LEAVE SQUAD", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("ADD FRIEND", style: TextStyle(fontFamily: 'Pixer')),
        children: service.friends.map((f) => SimpleDialogOption(
          child: Text(f.name),
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added ${f.name}")));
          },
        )).toList(),
      ),
    );
  }
}