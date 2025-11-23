import 'package:flutter/material.dart';

// --- Models ---
class Friend {
  final String name;
  final bool isOnline;
  String get avatar => _getAvatarForName(name);

  Friend({required this.name, this.isOnline = false});

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
    _currentUserAvatar = _generateMascot(_currentUserName);
  }

  String get currentUserName => _currentUserName;
  String get currentUserAvatar => _currentUserAvatar;
  List<String> get availableAvatars => _mascots;

  // Data Lists
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

  String _generateMascot(String name) {
    if (name.isEmpty) return "👾";
    int index = name.hashCode.abs() % _mascots.length;
    return _mascots[index];
  }

  void updateProfile(String newName) => updateName(newName);

  void updateName(String newName) {
    _currentUserName = newName;
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

  void addMemberToSquad(String squadId, String memberName) {
    final squadIndex = _squads.indexWhere((s) => s.id == squadId);
    if (squadIndex != -1) {
      final oldSquad = _squads[squadIndex];
      // MAX 4 CHECK
      if (!oldSquad.memberNames.contains(memberName) && oldSquad.memberNames.length < 4) {
        final newMembers = List<String>.from(oldSquad.memberNames)..add(memberName);
        _squads[squadIndex] = Squad(
            id: oldSquad.id, name: oldSquad.name, creatorName: oldSquad.creatorName, memberNames: newMembers
        );
        notifyListeners();
      }
    }
  }

  // Remove someone else (Kick)
  void removeMember(String squadId, String memberName) {
    final squadIndex = _squads.indexWhere((s) => s.id == squadId);
    if (squadIndex != -1) {
      final oldSquad = _squads[squadIndex];
      final newMembers = List<String>.from(oldSquad.memberNames)..remove(memberName);

      _squads[squadIndex] = Squad(
          id: oldSquad.id, name: oldSquad.name, creatorName: oldSquad.creatorName, memberNames: newMembers
      );
      notifyListeners();
    }
  }

  // NEW: LEAVE SQUAD (Self)
  // Removes the squad from your view entirely
  void leaveSquad(String squadId) {
    _squads.removeWhere((s) => s.id == squadId);
    notifyListeners();
  }
}