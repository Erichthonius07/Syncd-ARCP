import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friend_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import '../widgets/app_background.dart';

class FriendDetailScreen extends StatefulWidget {
  final Friend friend;
  const FriendDetailScreen({super.key, required this.friend});

  @override
  State<FriendDetailScreen> createState() => _FriendDetailScreenState();
}

class _FriendDetailScreenState extends State<FriendDetailScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      context.read<ChatService>().sendMessage(widget.friend.name, _controller.text);
      _controller.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatService = context.watch<ChatService>();
    final messages = chatService.getConversation(widget.friend.name);
    _scrollToBottom();

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Row(
          children: [
            Hero(
              tag: widget.friend.name,
              child: Icon(widget.friend.avatar, size: 28),
            ),
            const SizedBox(width: 12),
            Text(widget.friend.name),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.gamepad_outlined, size: 18),
              label: const Text("Invite"),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 14, fontFamily: 'Pixer'),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withAlpha(128),
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AppBackground(),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 120, bottom: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildChatBubble(message, theme);
                  },
                ),
              ),
              _buildChatInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Message message, ThemeData theme) {
    final isMyMessage = message.isSentByMe;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMyMessage
              ? theme.colorScheme.primary
              : Colors.black.withAlpha(100),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.text,
          style: const TextStyle(color: Colors.white, fontFamily: 'Roboto'),
        ),
      ),
    );
  }

  Widget _buildChatInput() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(fontFamily: 'Roboto', color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Send a message...',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(150)),
                filled: true,
                fillColor: Colors.black.withAlpha(100),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: theme.colorScheme.primary,
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}