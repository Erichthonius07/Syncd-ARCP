import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../theme.dart';
import 'neo_card.dart';

class CreateSquadDialog extends StatefulWidget {
  const CreateSquadDialog({super.key});

  @override
  State<CreateSquadDialog> createState() => _CreateSquadDialogState();
}

class _CreateSquadDialogState extends State<CreateSquadDialog> {
  final TextEditingController _nameController = TextEditingController();
  // In a real app, you'd have a multi-select list for friends here.
  // For now, we auto-add "You" and mock the selection logic.

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: NeoCard(
        color: AppTheme.background,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("NEW SQUAD", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
            const SizedBox(height: 20),

            // Name Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2),
              ),
              child: TextField(
                controller: _nameController,
                style: AppTheme.textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: "Squad Name (e.g. The Boys)",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Mock Member Selection Info
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Text("You + 3 Friends", style: AppTheme.textTheme.labelSmall),
              ],
            ),

            const SizedBox(height: 30),

            NeoCard(
              isButton: true,
              color: AppTheme.matrixGreen,
              onTap: () {
                if (_nameController.text.isNotEmpty) {
                  // Mocking selecting current user + 1 friend
                  Provider.of<FriendService>(context, listen: false).createSquad(
                      _nameController.text,
                      ["GAMER_ONE", "Selected_Friend"]
                  );
                  Navigator.pop(context);
                }
              },
              child: const Center(
                child: Text("ASSEMBLE", style: TextStyle(fontFamily: 'Pixer', fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}