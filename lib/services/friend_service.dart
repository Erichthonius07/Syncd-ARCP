import 'package:flutter/material.dart';
// Removed unused 'dart:math' import

// --- Models ---
class Friend {
  final String name;
  final bool isOnline;
  // Dynamic getter for avatar
  String get avatar => _getAvatarForName(name);

  Friend({required this.name, this.isOnline = false});

  // Helper to generate avatar based on name hash
  static String _getAvatarForName(String name) {
    final avatars = ["👾", "👽", "🤖", "💀", "🐱‍👤", "👺", "🤡", "👻", "🐉", "🦕", "🐺", "🐯", "🕹️", "🎲", "⚡", "🍄", "🍕", "🍔", "🚀", "🪐"];
    if (name.isEmpty) return avatars[0];
    return avatars[name.hashCode.abs() % avatars.length];
  }
}

class FriendRequest {
  final String name;
  FriendRequest({required this.name});
}

class Squad {
  final String id;
  final String name;
  final String creatorName;
  final List<String> memberNames;

  Squad({
    required this.id,
    required this.name,
    required this.creatorName,
    required this.memberNames
  });
}

// --- Service ---
class FriendService extends ChangeNotifier {

  // 1. POOL OF AVATARS
  final List<String> _mascots = [
    "👾", "👽", "🤖", "💀", "🐱‍👤",
    "👺", "👹", "🤡", "👻", "🧟",
    "🐉", "🦕", "🐺", "🐯", "🦍",
    "🕹️", "🎲", "⚡", "🍄", "💎",
    "👑", "🧢", "🎧", "🎸", "🚀"
  ];

  String _currentUserName = "GAMER_ONE";
  late String _currentUserAvatar;

  FriendService() {
    // Initialize avatar based on default name
    _currentUserAvatar = _generateMascot(_currentUserName);
  }

  String get currentUserName => _currentUserName;
  String get currentUserAvatar => _currentUserAvatar;
  List<String> get availableAvatars => _mascots;

  // 2. Data Lists
  final List<Friend> _friends = [
    Friend(name: "Alex_99", isOnline: true),
    Friend(name: "Sam.R", isOnline: false),
    Friend(name: "Glitch01", isOnline: true),
    Friend(name: "Sarah_C", isOnline: false),
  ];

  final List<FriendRequest> _friendRequests = [
    FriendRequest(name: "Gamer_X"),
  ];

  final List<Squad> _squads = [
    Squad(
        id: "1",
        name: "Weekend Warriors",
        creatorName: "GAMER_ONE",
        memberNames: ["GAMER_ONE", "Alex_99", "Glitch01"]
    ),
  ];

  List<Friend> get friends => _friends;
  List<FriendRequest> get friendRequests => _friendRequests;
  List<Squad> get squads => _squads;

  // --- LOGIC ---

  // Helper: Deterministic Avatar Generator
  String _generateMascot(String name) {
    if (name.isEmpty) return "👾";
    int index = name.hashCode.abs() % _mascots.length;
    return _mascots[index];
  }

  // Method called by MainMenuDialog
  void updateProfile(String newName) {
    updateName(newName); // Redirects to updateName
  }

  void updateName(String newName) {
    _currentUserName = newName;
    // Auto-update avatar to match new name (Gamer style)
    _currentUserAvatar = _generateMascot(newName);
    notifyListeners();
  }

  void updateAvatar(String newAvatar) {
    _currentUserAvatar = newAvatar;
    notifyListeners();
  }

  // Friend Actions
  void acceptRequest(FriendRequest request) {
    _friends.add(Friend(name: request.name, isOnline: true));
    _friendRequests.remove(request);
    notifyListeners();
  }

  void declineRequest(FriendRequest request) {
    _friendRequests.remove(request);
    notifyListeners();
  }

  void sendFriendRequest(String name) {
    debugPrint("Request sent to $name");
    notifyListeners();
  }

  // Squad Actions
  void createSquad(String name, List<String> members) {
    final newSquad = Squad(
        id: DateTime.now().toString(),
        name: name,
        creatorName: _currentUserName,
        memberNames: members
    );
    _squads.add(newSquad);
    notifyListeners();
  }
}