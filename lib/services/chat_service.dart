import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ChatService with ChangeNotifier {
  // A map to hold a list of messages for each friend's name
  final Map<String, List<Message>> _conversations = {
    'Alice': [
      Message(text: 'Hey! Want to play Halo later?', isSentByMe: false),
    ],
    'Bob': [],
  };

  // Get the conversation for a specific friend
  List<Message> getConversation(String friendName) {
    // If no conversation exists, create an empty one
    _conversations.putIfAbsent(friendName, () => []);
    return _conversations[friendName]!;
  }

  // Send a new message
  void sendMessage(String friendName, String text) {
    final conversation = getConversation(friendName);
    conversation.add(Message(text: text, isSentByMe: true));

    // In a real app, you would send the message to a server.
    // Here, we'll simulate a reply after a short delay.
    Future.delayed(const Duration(seconds: 1), () {
      conversation.add(Message(text: 'Sounds good!', isSentByMe: false));
      notifyListeners(); // This tells the UI to rebuild and show the new messages
    });

    notifyListeners();
  }
}