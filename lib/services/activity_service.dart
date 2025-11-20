import 'package:flutter/material.dart';

// 1. Define the Enum
enum ActivityType { game, friend, message, other }

// 2. Define the Model
class ActivityItem {
  final String text;
  final DateTime timestamp;
  final ActivityType type;

  ActivityItem({
    required this.text,
    required this.timestamp,
    required this.type
  });
}

class ActivityService extends ChangeNotifier {
  // 3. Mock Data
  final List<ActivityItem> _activityItems = [
    ActivityItem(
        text: "Played Cyber Racer",
        timestamp: DateTime.now(),
        type: ActivityType.game
    ),
    ActivityItem(
        text: "Alex_99 sent a request",
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        type: ActivityType.friend
    ),
    ActivityItem(
        text: "New high score in Space Tanks",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: ActivityType.game
    ),
  ];

  List<ActivityItem> get activityItems => _activityItems;

  void clearActivities() {
    _activityItems.clear();
    notifyListeners();
  }
}