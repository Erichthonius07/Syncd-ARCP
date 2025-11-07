import 'package:flutter/material.dart';
import '../widgets/menu_button.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withAlpha(230),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 70, bottom: 20),
                shrinkWrap: true,
                children: [
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
                    onTap: () {},
                  ),
                  MenuButton(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  MenuButton(
                    icon: Icons.help_outline,
                    title: 'Help & Feedback',
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  MenuButton(
                    icon: Icons.logout,
                    title: 'Logout',
                    color: theme.colorScheme.secondary,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: theme.scaffoldBackgroundColor,
            child: Icon(
              Icons.person_outline,
              size: 50,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Positioned(
            top: 60,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}