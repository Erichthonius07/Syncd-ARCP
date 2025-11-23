import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _sounds = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = AppTheme.c(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backIconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, size: 32, color: backIconColor),
                    ),
                    const SizedBox(width: 16),
                    Text("SETTINGS", style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
                const SizedBox(height: 30),

                // Toggles
                _buildToggle("NOTIFICATIONS", _notifications, (v) => setState(() => _notifications = v), colors),
                const SizedBox(height: 16),
                _buildToggle("GAME SOUNDS", _sounds, (v) => setState(() => _sounds = v), colors),
                const SizedBox(height: 16),
                _buildToggle("DARK MODE", themeProvider.isDarkMode, (v) => themeProvider.toggleTheme(v), colors),

                const SizedBox(height: 40),
                Text("ACCOUNT", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 16),

                NeoCard(
                  color: colors.surface,
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Change Password", style: Theme.of(context).textTheme.bodyLarge),
                      Icon(Icons.lock_outline, color: colors.accentIcon),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                NeoCard(
                  color: colors.surface,
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Privacy Policy", style: Theme.of(context).textTheme.bodyLarge),
                      Icon(Icons.privacy_tip_outlined, color: colors.accentIcon),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String title, bool value, Function(bool) onChanged, SyncPalette colors) {
    return NeoCard(
      // If value is true, use Neon Green (Success). If false, use Surface.
      color: value ? colors.success : colors.surface,
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // FIX: Removed manual color override. NeoCard handles it now.
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Pixer', fontSize: 18)),
          Icon(value ? Icons.toggle_on : Icons.toggle_off, size: 32),
        ],
      ),
    );
  }
}