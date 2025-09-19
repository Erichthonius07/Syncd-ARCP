import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../widgets/activity_list_item.dart'; // ✅ 1. Import the new widget

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final List<ActivityItem> _activityItems = [
    // ... (your mock data is unchanged)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _activityItems.length,
        itemBuilder: (context, index) {
          final item = _activityItems[index];
          // ✅ 2. Replace the Card/ListTile with our custom widget
          return ActivityListItem(item: item);
        },
      ),
    );
  }
}