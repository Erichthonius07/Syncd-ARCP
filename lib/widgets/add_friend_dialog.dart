import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../theme.dart';
import 'neo_card.dart';

class AddFriendDialog extends StatefulWidget {
  const AddFriendDialog({super.key});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: NeoCard(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("ADD FRIEND", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
            const SizedBox(height: 20),

            NeoCard(
              color: Theme.of(context).cardColor,
              child: TextField(
                controller: _controller,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: "Enter username...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            NeoCard(
              isButton: true,
              color: AppTheme.electricBlue,
              onTap: () {
                if (_controller.text.isNotEmpty) {
                  // Access provider internally
                  Provider.of<FriendService>(context, listen: false).sendFriendRequest(_controller.text);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Request sent to ${_controller.text}")));
                }
              },
              child: const Center(
                child: Text("SEND REQUEST", style: TextStyle(fontFamily: 'Pixer', fontSize: 18, color: Colors.black)),
              ),
            )
          ],
        ),
      ),
    );
  }
}