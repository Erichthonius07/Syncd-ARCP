import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityService with ChangeNotifier {
  final List<ActivityItem> _activityItems = [
    ActivityItem(
      title: 'Bob sent you a game invite!',
      subtitle: 'Game: Halo - 10 minutes ago',
      icon: Icons.person_add,
      type: ActivityType.game,
    ),
    ActivityItem(
      title: 'Alice is now online',
      subtitle: '1 hour ago',
      icon: Icons.wifi,
      type: ActivityType.friend,
    ),
    ActivityItem(
      title: 'You unlocked a new achievement',
      subtitle: 'Game: Doom - Yesterday',
      icon: Icons.star_border,
      type: ActivityType.game,
    ),
    ActivityItem(
      title: 'Charlie sent you a friend request',
      subtitle: '2 days ago',
      icon: Icons.person_add_alt_1,
      type: ActivityType.friend,
    ),
  ];

  List<ActivityItem> get activityItems => _activityItems;

  void clearActivities() {
    _activityItems.clear();
    notifyListeners(); // This tells the UI to rebuild
  }
}