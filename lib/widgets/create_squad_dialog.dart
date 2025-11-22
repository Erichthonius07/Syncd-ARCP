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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: NeoCard(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("NEW SQUAD", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(width: 2, color: Theme.of(context).dividerColor),
              ),
              child: TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: "Squad Name (e.g. The Boys)",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Text("You + 3 Friends", style: Theme.of(context).textTheme.labelSmall),
              ],
            ),

            const SizedBox(height: 30),

            NeoCard(
              isButton: true,
              color: AppTheme.matrixGreen,
              onTap: () {
                if (_nameController.text.isNotEmpty) {
                  Provider.of<FriendService>(context, listen: false).createSquad(
                      _nameController.text,
                      ["GAMER_ONE", "Selected_Friend"]
                  );
                  Navigator.pop(context);
                }
              },
              child: const Center(
                child: Text("ASSEMBLE", style: TextStyle(fontFamily: 'Pixer', fontSize: 18, color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }
}