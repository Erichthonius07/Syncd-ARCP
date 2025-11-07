import 'package:flutter/material.dart';

enum ActivityType { friend, game }

class ActivityItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final ActivityType type;

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.type,
  });
}