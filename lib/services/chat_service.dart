import 'package:flutter/material.dart';

class Message {
  final String text;
  final bool isMe; // Fixed: Added this field

  Message({required this.text, required this.isMe});
}

class ChatService extends ChangeNotifier {
  // Mock Data
  final List<Message> _messages = [
    Message(text: "Hey! Ready for the game?", isMe: false),
    Message(text: "Yeah, just loading up now.", isMe: true),
  ];

  List<Message> getConversation(String friendName) {
    return _messages;
  }

  void sendMessage(String friendName, String text) {
    _messages.insert(0, Message(text: text, isMe: true));
    notifyListeners();

    // Mock reply simulation
    Future.delayed(const Duration(seconds: 1), () {
      _messages.insert(0, Message(text: "Ok, joining lobby...", isMe: false));
      notifyListeners();
    });
  }
}