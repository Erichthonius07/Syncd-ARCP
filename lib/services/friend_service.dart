import 'package:flutter/material.dart';
import '../models/friend_model.dart';
import '../models/friend_request_model.dart';

class FriendService with ChangeNotifier {
  final List<Friend> _friends = [
    Friend(name: 'Alice', avatar: Icons.person_outline),
    Friend(name: 'Bob', avatar: Icons.person_outline),
    Friend(name: 'Charlie', avatar: Icons.person_outline),
  ];
  List<Friend> get friends => _friends;

  final List<FriendRequest> _friendRequests = [
    FriendRequest(name: 'Zane'),
    FriendRequest(name: 'Xavier'),
  ];
  List<FriendRequest> get friendRequests => _friendRequests;

  void acceptRequest(FriendRequest request) {
    _friendRequests.remove(request);
    _friends.add(Friend(name: request.name, avatar: Icons.person_outline));
    notifyListeners();
  }

  void declineRequest(FriendRequest request) {
    _friendRequests.remove(request);
    notifyListeners();
  }

  void sendFriendRequest(String name) {
    // In a real app, you would send this to a server.
    notifyListeners();
  }
}