import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../models/friend_request_model.dart';

class FriendService with ChangeNotifier {
  final List<Friend> _friends = [
    Friend(name: 'Alice', avatar: Icons.person_outline),
    Friend(name: 'Bob', avatar: Icons.person_outline),
    Friend(name: 'Charlie', avatar: Icons.person_outline),
    Friend(name: 'David', avatar: Icons.person_outline),
    Friend(name: 'Eve', avatar: Icons.person_outline),
  ];

  List<Friend> get friends => _friends;

  final List<FriendRequest> _friendRequests = [
    FriendRequest(name: 'Zane'),
    FriendRequest(name: 'Xavier'),
  ];

  // A public getter for the requests list
  List<FriendRequest> get friendRequests => _friendRequests;
  // ✅ 1. ADD a method to accept a friend request
  void acceptRequest(FriendRequest request) {
    _friendRequests.remove(request); // Remove from requests
    _friends.add(Friend(name: request.name, avatar: Icons.person_outline)); // Add to friends
    notifyListeners(); // This tells the UI to rebuild and show the changes!
  }

  // ✅ 2. ADD a method to decline a friend request
  void declineRequest(FriendRequest request) {
    _friendRequests.remove(request);
    notifyListeners(); // Tell the UI to rebuild
  }

  // ✅ 3. ADD a method to send a new friend request
  void sendFriendRequest(String name) {
    // In a real app, you would send this to a server.
    // For now, we'll just leave this empty as a placeholder.
    // The print statement has been removed.
    notifyListeners();
  }
}