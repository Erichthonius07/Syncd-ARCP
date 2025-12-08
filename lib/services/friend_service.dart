import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- Models ---
class Friend {
  final String name;
  final bool isOnline;
  final String avatar;

  Friend({required this.name, this.isOnline = false, this.avatar = "👾"});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['username'] ?? 'Unknown',
      isOnline: json['online'] ?? false,
      avatar: json['avatarIcon'] ?? "👾",
    );
  }
}

class FriendRequest {
  final String name; // Username of the sender

  FriendRequest({required this.name});

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    // Backend returns User object for pending requests
    return FriendRequest(name: json['username'] ?? 'Unknown');
  }
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
  // ⚠️ IP Address configured for your setup
  static const String baseUrl = 'http://192.168.29.250:8080/api';

  // Available avatars for UI selection
  final List<String> _mascots = [
    "👾", "👽", "🤖", "💀", "🐱‍👤",
    "👺", "👹", "🤡", "👻", "🧟",
    "🐉", "🦕", "🐺", "🐯", "🦍",
    "🕹️", "🎲", "⚡", "🍄", "💎",
    "👑", "🧢", "🎧", "🎸", "🚀"
  ];

  String _currentUserName = "Loading...";
  String _currentUserAvatar = "👾";

  List<Friend> _friends = [];
  List<FriendRequest> _friendRequests = [];
  final List<Squad> _squads = [];

  List<Friend> get friends => _friends;
  List<FriendRequest> get friendRequests => _friendRequests;
  List<Squad> get squads => _squads;

  String get currentUserName => _currentUserName;
  String get currentUserAvatar => _currentUserAvatar;
  List<String> get availableAvatars => _mascots;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // --- INITIALIZATION ---
  Future<void> initialize() async {
    await fetchUserProfile();
    await fetchFriends();
    await fetchRequests();
  }

  // --- PROFILE ---
  Future<void> fetchUserProfile() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/me'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUserName = data['username'];
        _currentUserAvatar = data['avatarIcon'] ?? "👾";
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

  // --- LOCAL UPDATES ---
  void updateName(String newName) {
    _currentUserName = newName;
    notifyListeners();
    // TODO: Add backend sync
  }

  void updateAvatar(String newAvatar) {
    _currentUserAvatar = newAvatar;
    notifyListeners();
    // TODO: Add backend sync
  }

  // --- FRIENDS & REQUESTS (Backend Integrated) ---
  Future<void> fetchFriends() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/friends'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _friends = data.map((json) => Friend.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching friends: $e");
    }
  }

  Future<void> fetchRequests() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/friends/requests'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        _friendRequests = data.map((json) => FriendRequest.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching requests: $e");
    }
  }

  Future<bool> sendFriendRequest(String username) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/friends/request/$username'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error sending request: $e");
      return false;
    }
  }

  Future<List<dynamic>> searchUsers(String query) async {
    final token = await _getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/friends/search?query=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Error searching users: $e");
    }
    return [];
  }

  // --- RESPOND ---
  Future<void> acceptRequest(FriendRequest request) async {
    await _respondToRequest(request.name, true);
    // Optimistic update
    _friendRequests.remove(request);
    await fetchFriends();
    notifyListeners();
  }

  Future<void> declineRequest(FriendRequest request) async {
    await _respondToRequest(request.name, false);
    _friendRequests.remove(request);
    notifyListeners();
  }

  Future<void> _respondToRequest(String senderUsername, bool accept) async {
    final token = await _getToken();
    if (token == null) return;

    try {
      await http.put(
        Uri.parse('$baseUrl/friends/respond'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'senderUsername': senderUsername,
          'accept': accept
        }),
      );
    } catch (e) {
      debugPrint("Error responding: $e");
    }
  }

  // --- SQUADS (Local Logic Preserved) ---
  void createSquad(String name, List<String> members) {
    final newSquad = Squad(
        id: DateTime.now().toString(),
        name: name,
        creatorName: _currentUserName,
        memberNames: [_currentUserName, ...members]
    );
    _squads.add(newSquad);
    notifyListeners();
  }

  void addMemberToSquad(String squadId, String memberName) {
    final squadIndex = _squads.indexWhere((s) => s.id == squadId);
    if (squadIndex != -1) {
      final oldSquad = _squads[squadIndex];
      // Max 4 Check
      if (!oldSquad.memberNames.contains(memberName) && oldSquad.memberNames.length < 4) {
        final newMembers = List<String>.from(oldSquad.memberNames)..add(memberName);
        _squads[squadIndex] = Squad(
            id: oldSquad.id,
            name: oldSquad.name,
            creatorName: oldSquad.creatorName,
            memberNames: newMembers
        );
        notifyListeners();
      }
    }
  }

  void removeMember(String squadId, String memberName) {
    final squadIndex = _squads.indexWhere((s) => s.id == squadId);
    if (squadIndex != -1) {
      final oldSquad = _squads[squadIndex];
      final newMembers = List<String>.from(oldSquad.memberNames)..remove(memberName);

      _squads[squadIndex] = Squad(
          id: oldSquad.id,
          name: oldSquad.name,
          creatorName: oldSquad.creatorName,
          memberNames: newMembers
      );
      notifyListeners();
    }
  }

  void leaveSquad(String squadId) {
    _squads.removeWhere((s) => s.id == squadId);
    notifyListeners();
  }
}