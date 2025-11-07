import 'package:flutter/material.dart'; // ✅ THE MISSING IMPORT
import '../widgets/menu_button.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.onSurface.withAlpha(50),
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Username",
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          MenuButton(
            icon: Icons.account_circle_outlined,
            title: 'Profile',
            onTap: () { /* TODO: Navigate to Profile */ },
          ),
          MenuButton(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () { /* TODO: Navigate to Settings */ },
          ),
          MenuButton(
            icon: Icons.help_outline,
            title: 'Help & Feedback',
            onTap: () { /* TODO: Navigate to Help */ },
          ),
          const SizedBox(height: 20),
          MenuButton(
            icon: Icons.logout,
            title: 'Logout',
            color: theme.colorScheme.secondary,
            onTap: () { /* TODO: Implement logout logic */ },
          ),
        ],
      ),
    );
  }
}