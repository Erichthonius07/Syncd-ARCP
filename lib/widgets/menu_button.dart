import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const MenuButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = color ?? Colors.white70;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor.withAlpha(230), // Corrected opacity
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.onSurface.withAlpha(100)),
        ),
        child: Row(
          children: [
            Icon(icon, color: itemColor, size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(color: itemColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: itemColor, size: 16),
          ],
        ),
      ),
    );
  }
}