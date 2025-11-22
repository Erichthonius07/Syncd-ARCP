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
                      child: const Icon(Icons.arrow_back, size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Text("SETTINGS", style: TextStyle(fontFamily: 'Pixer', fontSize: 32)),
                  ],
                ),
                const SizedBox(height: 30),

                _buildToggle("NOTIFICATIONS", _notifications, (v) => setState(() => _notifications = v)),
                const SizedBox(height: 16),
                _buildToggle("GAME SOUNDS", _sounds, (v) => setState(() => _sounds = v)),
                const SizedBox(height: 16),
                _buildToggle("DARK MODE", themeProvider.isDarkMode, (v) => themeProvider.toggleTheme(v)),

                const SizedBox(height: 40),
                const Text("ACCOUNT", style: TextStyle(fontFamily: 'Pixer', fontSize: 18)),
                const SizedBox(height: 16),

                NeoCard(
                  color: Theme.of(context).cardColor,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Reset Password", style: TextStyle(fontFamily: 'Pixer')),
                        content: const Text("Link sent to email."),
                        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Change Password", style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.lock_outline)],
                  ),
                ),
                const SizedBox(height: 16),
                NeoCard(
                  color: Theme.of(context).cardColor,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Browser..."))),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.bold)), Icon(Icons.privacy_tip_outlined)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggle(String title, bool value, Function(bool) onChanged) {
    return NeoCard(
      color: value ? AppTheme.matrixGreen : Theme.of(context).cardColor,
      onTap: () => onChanged(!value),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: value ? Colors.black : Theme.of(context).textTheme.bodyLarge!.color)),
          Icon(value ? Icons.toggle_on : Icons.toggle_off, size: 32, color: value ? Colors.black : Theme.of(context).iconTheme.color),
        ],
      ),
    );
  }
}