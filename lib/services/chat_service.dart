import 'package:flutter/material.dart';

class Message {
  final String text;
  final bool isMe;
  final String senderName; // NEW: Store who sent it

  Message({
    required this.text,
    required this.isMe,
    required this.senderName
  });
}

class ChatService extends ChangeNotifier {
  // Mock Data
  final List<Message> _messages = [
    Message(text: "Ready to start?", isMe: false, senderName: "Alex_99"),
    Message(text: "Yeah, inviting the squad now.", isMe: true, senderName: "GAMER_ONE"),
  ];

  List<Message> getConversation(String friendName) {
    return _messages;
  }

  void sendMessage(String senderName, String text) {
    // Add "You" as the sender for local display
    _messages.insert(0, Message(text: text, isMe: true, senderName: "You"));
    notifyListeners();

    // Mock Reply
    Future.delayed(const Duration(seconds: 1), () {
      _messages.insert(0, Message(text: "Got it!", isMe: false, senderName: "Alex_99"));
      notifyListeners();
    });
  }
}