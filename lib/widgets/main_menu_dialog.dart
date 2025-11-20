import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../theme.dart';
import 'neo_card.dart';

import '../screens/settings_screen.dart';
import '../screens/feedback_screen.dart';
import '../screens/report_bug_screen.dart';

class MainMenuDialog extends StatelessWidget {
  const MainMenuDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final friendService = Provider.of<FriendService>(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(width: 3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 6,
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(height: 30),

          // Profile Header
          Row(
            children: [
              GestureDetector(
                onTap: () => _showEditProfileDialog(context, friendService),
                child: Stack(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        color: AppTheme.electricBlue,
                        shape: BoxShape.circle,
                        border: Border.all(width: 3),
                      ),
                      child: Center(
                          child: Text(
                              friendService.currentUserAvatar,
                              style: const TextStyle(fontFamily: 'Pixer', fontSize: 24, color: Colors.black)
                          )
                      ),
                    ),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2),
                        ),
                        child: const Icon(Icons.edit, size: 10),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            friendService.currentUserName,
                            style: AppTheme.textTheme.displayMedium!.copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showEditProfileDialog(context, friendService),
                          child: const Icon(Icons.edit, size: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text("Online Status: Visible", style: AppTheme.textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Menu Options
          _buildMenuOption(context, "SETTINGS", Icons.settings, AppTheme.electricBlue, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          _buildMenuOption(context, "FEEDBACK", Icons.comment, AppTheme.cyberYellow, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
          }),
          _buildMenuOption(context, "REPORT BUG", Icons.bug_report, Colors.white, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportBugScreen()));
          }),

          // LOGOUT FIX
          _buildMenuOption(context, "LOGOUT", Icons.exit_to_app, AppTheme.hotPink, () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, String text, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: NeoCard(
        onTap: onTap,
        color: color,
        isButton: true,
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 16),
            Text(text, style: const TextStyle(fontFamily: 'Pixer', fontSize: 18, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, FriendService service) {
    final TextEditingController controller = TextEditingController(text: service.currentUserName);

    showDialog(
        context: context,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          child: NeoCard(
            color: AppTheme.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("EDIT PROFILE", style: TextStyle(fontFamily: 'Pixer', fontSize: 24)),
                const SizedBox(height: 16),

                NeoCard(
                  color: Colors.white,
                  child: TextField(
                    controller: controller,
                    style: AppTheme.textTheme.bodyLarge,
                    decoration: const InputDecoration(hintText: "Enter new name", border: InputBorder.none),
                  ),
                ),

                const SizedBox(height: 20),
                const Align(alignment: Alignment.centerLeft, child: Text("CHOOSE ICON", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 8, crossAxisSpacing: 8),
                    itemCount: service.availableAvatars.length,
                    itemBuilder: (ctx, index) {
                      final avatar = service.availableAvatars[index];
                      final isSelected = service.currentUserAvatar == avatar;
                      return GestureDetector(
                        onTap: () => service.updateAvatar(avatar),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.cyberYellow : Colors.white,
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(child: Text(avatar, style: const TextStyle(fontSize: 20))),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),
                NeoCard(
                  color: AppTheme.matrixGreen,
                  isButton: true,
                  onTap: () {
                    if (controller.text.isNotEmpty) service.updateName(controller.text);
                    Navigator.pop(ctx);
                  },
                  child: const Center(child: Text("SAVE", style: TextStyle(fontFamily: 'Pixer', fontSize: 18))),
                )
              ],
            ),
          ),
        )
    );
  }
}