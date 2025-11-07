import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/activity_service.dart';
import '../widgets/activity_list_item.dart';
import '../widgets/app_background.dart';
import '../widgets/empty_state_widget.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityService = context.watch<ActivityService>();
    final activityItems = activityService.activityItems;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Activity'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (activityItems.isNotEmpty)
            TextButton(
              onPressed: () {
                activityService.clearActivities();
              },
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: activityItems.isEmpty
                ? const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              message: "You have no new activity.",
            )
                : ListView.builder(
              itemCount: activityItems.length,
              itemBuilder: (context, index) {
                final item = activityItems[index];
                return ActivityListItem(
                  item: item,
                  onTap: () {
                    // TODO: Implement navigation based on activity type
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}