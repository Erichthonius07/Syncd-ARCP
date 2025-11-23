import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../widgets/neo_card.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/main_menu_dialog.dart';
import '../widgets/create_squad_dialog.dart';
import '../widgets/add_friend_dialog.dart';
import '../theme.dart';
import 'friends_management_screen.dart';
import 'game_selection_screen.dart';
import 'squad_detail_screen.dart';
import 'my_games_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = Friends (DMs), 1 = Squads (Parties)
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final friendService = Provider.of<FriendService>(context);
    final hasInvites = friendService.friendRequests.isNotEmpty;

    // Get the Semantic Palette (Handles Light/Dark mode automatically)
    final colors = AppTheme.c(context);

    // Theme properties for conditional styling
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final consoleColor = isDark ? AppTheme.consoleGreyDark : AppTheme.consoleGreyLight;
    final iconColor = Theme.of(context).iconTheme.color;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    // --- 1. HEADER (Profile & Quick Actions) ---
                    Row(
                      children: [
                        // Avatar (Click to Open Menu)
                        GestureDetector(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const MainMenuDialog(),
                          ),
                          child: Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(
                              color: colors.actionLibrary,
                              border: Border.all(width: 2, color: colors.outline),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: colors.outline, offset: const Offset(2, 2))],
                            ),
                            child: Center(
                              child: Text(
                                friendService.currentUserAvatar,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // User Name & Status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friendService.currentUserName,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 22),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Container(
                                      width: 8, height: 8,
                                      decoration: BoxDecoration(color: colors.success, shape: BoxShape.circle)
                                  ),
                                  const SizedBox(width: 6),
                                  Text("ONLINE", style: Theme.of(context).textTheme.labelSmall),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Add Friend Button
                        NeoCard(
                          onTap: () => showDialog(context: context, builder: (_) => const AddFriendDialog()),
                          color: colors.success,
                          child: const Icon(Icons.person_add, color: Colors.black),
                        ),
                        const SizedBox(width: 8),

                        // Settings Button
                        NeoCard(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const MainMenuDialog(),
                          ),
                          color: consoleColor,
                          child: Icon(Icons.settings, color: iconColor),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- 2. CONTROLLER GRID (Asymmetric Layout) ---
                    // Left: Big Host Button | Right: Stacked Join & Inbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HOST (Big Left)
                        Expanded(
                          flex: 6,
                          child: NeoCard(
                            height: 160, // Tall enough to match the 2 stacked buttons
                            color: colors.actionHost,
                            isButton: true,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameSelectionScreen())
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -10, bottom: -10,
                                  child: Icon(Icons.gamepad, size: 100, color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
                                      child: const Text("START", style: TextStyle(color: Colors.white, fontFamily: 'Pixer', fontSize: 12)),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("HOST\nGAME", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white, height: 1.1)),
                                        const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // RIGHT COLUMN (Join & Inbox)
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              // JOIN
                              NeoCard(
                                height: 72,
                                color: colors.actionJoin,
                                isButton: true,
                                onTap: () => Navigator.pushNamed(context, '/join'),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.login, size: 20, color: Colors.black),
                                      const SizedBox(width: 8),
                                      Text("JOIN", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // INBOX
                              NeoCard(
                                height: 72,
                                color: colors.surface, // Surface color distinguishes utility from action
                                isButton: true,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsManagementScreen())),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.mail_outline, size: 20, color: colors.accentIcon),
                                          const SizedBox(height: 4),
                                          Text("INBOX", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    if (hasInvites)
                                      Positioned(
                                        right: 0, top: 0,
                                        child: Container(
                                          width: 12, height: 12,
                                          decoration: BoxDecoration(
                                            color: colors.actionHost,
                                            shape: BoxShape.circle,
                                            border: Border.all(width: 2),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // --- 3. LIBRARY BAR (Full Width) ---
                    NeoCard(
                      height: 60,
                      color: colors.actionLibrary,
                      isButton: true,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyGamesScreen())),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.apps, color: Colors.black),
                          const SizedBox(width: 12),
                          Text("LIBRARY", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- 4. TABS (Friends vs Squads) ---
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        border: Border.all(width: 2, color: colors.outline),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: colors.outline, offset: const Offset(2, 2))],
                      ),
                      child: Row(
                        children: [
                          _buildToggleTab("FRIENDS", 0, context),
                          _buildToggleTab("SQUADS", 1, context),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // --- 5. CONTENT LIST ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _currentTab == 0
                      ? _buildFriendsList(friendService, consoleColor, context)
                      : _buildSquadsList(friendService, context),
                ),
              ),
            ],
          ),
        ),
      ),

      // FAB for Creating Squads (Only visible on Squad Tab)
      floatingActionButton: _currentTab == 1
          ? FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (_) => const CreateSquadDialog()),
        backgroundColor: colors.outline,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: colors.surface, width: 2)
        ),
        child: Icon(Icons.add, color: colors.surface),
      )
          : null,
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildToggleTab(String text, int index, BuildContext context) {
    final isSelected = _currentTab == index;
    final colors = AppTheme.c(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? colors.outline : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pixer',
              fontSize: 16,
              color: isSelected ? colors.surface : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList(FriendService service, Color consoleColor, BuildContext context) {
    final colors = AppTheme.c(context);
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: service.friends.length,
      itemBuilder: (context, index) {
        final friend = service.friends[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NeoCard(
            onTap: () => Navigator.pushNamed(context, '/chat', arguments: friend.name),
            child: Row(
              children: [
                Container(
                  width: 45, height: 45,
                  decoration: BoxDecoration(
                    color: consoleColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2, color: colors.outline),
                  ),
                  child: Center(
                      child: Text(
                          friend.avatar,
                          style: const TextStyle(fontSize: 24)
                      )
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(friend.name, style: Theme.of(context).textTheme.bodyLarge),
                    Text(
                      friend.isOnline ? "ONLINE" : "OFFLINE",
                      style: TextStyle(
                          color: friend.isOnline ? colors.success : Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: colors.accentIcon),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSquadsList(FriendService service, BuildContext context) {
    final colors = AppTheme.c(context);

    // Empty State using Theme Colors
    if (service.squads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_2_outlined, size: 64, color: colors.outline.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text("NO SQUADS FOUND", style: Theme.of(context).textTheme.displaySmall!.copyWith(color: colors.outline.withValues(alpha: 0.5))),
            const SizedBox(height: 8),
            Text("Tap + to create a team", style: TextStyle(color: colors.outline.withValues(alpha: 0.5))),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: service.squads.length,
      itemBuilder: (context, index) {
        final squad = service.squads[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NeoCard(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SquadDetailScreen(squad: squad))
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(squad.name, style: Theme.of(context).textTheme.bodyLarge),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: colors.outline,
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text(
                          "${squad.memberNames.length}/4",
                          style: TextStyle(color: colors.surface, fontSize: 10, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 2, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: squad.memberNames.map((m) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(
                            color: colors.actionLibrary,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(),
                          ),
                          child: Center(
                              child: Text(
                                  m.isNotEmpty ? m[0] : "?",
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)
                              )
                          ),
                        ),
                      )).toList(),
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context,
                            '/chat',
                            arguments: {'name': squad.name, 'isSquad': true}
                        ),
                        child: Icon(Icons.message, size: 16, color: colors.accentIcon)
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}