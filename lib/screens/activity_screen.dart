import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/activity_service.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityService = Provider.of<ActivityService>(context);
    final activities = activityService.activityItems;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("LOGS", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final item = activities[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: NeoCard(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.consoleGrey,
                                  border: Border.all(width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(_getIconForType(item.type), size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.text, style: AppTheme.textTheme.bodyMedium),
                                    Text("Just now", style: AppTheme.textTheme.labelSmall),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(ActivityType type) {
    switch (type) {
      case ActivityType.game: return Icons.gamepad;
      case ActivityType.friend: return Icons.person_add;
      default: return Icons.info;
    }
  }
}