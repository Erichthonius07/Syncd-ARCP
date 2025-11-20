import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import '../widgets/dot_grid_background.dart';
import '../theme.dart';
import 'game_selection_screen.dart';

class FriendDetailScreen extends StatelessWidget {
  final String friendName;

  const FriendDetailScreen({super.key, required this.friendName});

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final messages = chatService.getConversation(friendName);
    final TextEditingController msgController = TextEditingController();

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // --- HEADER ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(width: 3)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.consoleGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 2),
                      ),
                      child: Text(friendName[0], style: AppTheme.textTheme.displaySmall),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(friendName, style: AppTheme.textTheme.displaySmall!.copyWith(fontSize: 20))
                    ),

                    // Invite Button
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameSelectionScreen())),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.electricBlue,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)],
                        ),
                        child: const Icon(Icons.gamepad, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // --- CHAT LIST ---
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.isMe;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        constraints: const BoxConstraints(maxWidth: 260),
                        decoration: BoxDecoration(
                          color: isMe ? AppTheme.cyberYellow : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                          ),
                          border: Border.all(width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0)],
                        ),
                        child: Text(
                          msg.text,
                          style: AppTheme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // --- INPUT BAR ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(width: 3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 2),
                        ),
                        child: TextField(
                          controller: msgController,
                          style: AppTheme.textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            hintText: "Message...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        if (msgController.text.isNotEmpty) {
                          chatService.sendMessage(friendName, msgController.text);
                          msgController.clear();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.hotPink,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)],
                        ),
                        child: const Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}