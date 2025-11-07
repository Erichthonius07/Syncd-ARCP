import 'package:flutter/material.dart';
import '../services/friend_service.dart'; // Import the service

class AddFriendDialog extends StatefulWidget {
  final FriendService friendService;
  const AddFriendDialog({super.key, required this.friendService});

  @override
  State<AddFriendDialog> createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1B1717),
      title: const Text('Add a Friend'),
      content: TextField(
        controller: _controller, // Use a controller to get the text
        decoration: const InputDecoration(
          hintText: "Enter friend's username",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // ✅ WIRE UP the "Send Request" button
            if (_controller.text.isNotEmpty) {
              widget.friendService.sendFriendRequest(_controller.text);
            }
            Navigator.of(context).pop();
          },
          child: const Text('Send Request'),
        ),
      ],
    );
  }
}