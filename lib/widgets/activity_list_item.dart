import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityListItem extends StatelessWidget {
  final ActivityItem item;
  final VoidCallback onTap;

  const ActivityListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = item.type == ActivityType.game
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(51),
          border: Border(
            left: BorderSide(
              color: iconColor,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(item.icon, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: TextStyle(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}