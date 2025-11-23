import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import '../widgets/dot_grid_background.dart';
import '../theme.dart';
import 'game_selection_screen.dart';

class FriendDetailScreen extends StatelessWidget {
  final String friendName;
  final bool isSquad;

  const FriendDetailScreen({super.key, required this.friendName, this.isSquad = false});

  bool _isOnlyEmoji(String text) {
    if (text.isEmpty) return false;
    final RegExp emojiRegex = RegExp(r'^[\u{1F300}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}]+$', unicode: true);
    return emojiRegex.hasMatch(text) && text.length < 10;
  }

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final messages = chatService.getConversation(friendName);
    final TextEditingController msgController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border(bottom: BorderSide(width: 3, color: Theme.of(context).dividerColor)),
                ),
                child: Row(
                  children: [
                    IconButton(icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color), onPressed: () => Navigator.pop(context)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(friendName, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20))),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameSelectionScreen())),
                      child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppTheme.electricBlue, borderRadius: BorderRadius.circular(8), border: Border.all(width: 2, color: Colors.black), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)]), child: const Icon(Icons.gamepad, size: 20, color: Colors.black)),
                    ),
                  ],
                ),
              ),

              // MESSAGES
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.isMe;
                    final isBigEmoji = _isOnlyEmoji(msg.text);

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          // SENDER NAME DISPLAY
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 4, right: 4),
                            child: Text(
                                isMe ? "You" : msg.senderName, // Explicitly shows "You" or Name
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isMe ? AppTheme.cyberYellow : Theme.of(context).textTheme.labelSmall!.color
                                )
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: isBigEmoji ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: isBigEmoji ? null : BoxDecoration(
                              color: isMe ? AppTheme.cyberYellow : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                                bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                              ),
                              border: Border.all(width: 2, color: isMe ? Colors.black : Theme.of(context).dividerColor),
                              boxShadow: isBigEmoji ? [] : [BoxShadow(color: Theme.of(context).dividerColor, offset: const Offset(2, 2))],
                            ),
                            child: Text(msg.text, style: TextStyle(fontSize: isBigEmoji ? 48 : 14, fontWeight: FontWeight.bold, color: isMe ? Colors.black : Theme.of(context).textTheme.bodyMedium!.color)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // INPUT
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, border: Border(top: BorderSide(width: 3, color: Theme.of(context).dividerColor))),
                child: Row(
                  children: [
                    Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(30), border: Border.all(width: 2, color: Theme.of(context).dividerColor)), child: TextField(controller: msgController, style: Theme.of(context).textTheme.bodyMedium, decoration: const InputDecoration(hintText: "Message...", border: InputBorder.none)))),
                    const SizedBox(width: 12),
                    GestureDetector(
                        onTap: () {
                          if (msgController.text.isNotEmpty) {
                            // Pass "You" (or actual username) here
                            chatService.sendMessage("GAMER_ONE", msgController.text);
                            msgController.clear();
                          }
                        },
                        child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppTheme.hotPink, shape: BoxShape.circle, border: Border.all(width: 2, color: Colors.black), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)]), child: const Icon(Icons.send, color: Colors.white, size: 20))
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