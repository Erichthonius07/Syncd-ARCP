import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/friend_service.dart';
import '../widgets/neo_card.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/main_menu_dialog.dart';
import '../widgets/create_squad_dialog.dart';
import '../theme.dart';
import 'friends_management_screen.dart';
import 'game_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final friendService = Provider.of<FriendService>(context);
    final hasInvites = friendService.friendRequests.isNotEmpty;

    // Dynamic Colors
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final consoleColor = isDark ? AppTheme.consoleGreyDark : AppTheme.consoleGreyLight;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    // --- HEADER ---
                    Row(
                      children: [
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
                              color: AppTheme.electricBlue,
                              border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: isDark ? Colors.white : Colors.black, offset: const Offset(2, 2))],
                            ),
                            child: Center(
                              child: Text(
                                friendService.currentUserAvatar,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friendService.currentUserName,
                                style: textTheme.displayMedium!.copyWith(fontSize: 22),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: 8, height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.matrixGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text("ONLINE", style: textTheme.labelSmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                        NeoCard(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true, // Important for keyboard
                            builder: (_) => const MainMenuDialog(),
                          ),
                          color: consoleColor, // Fixed
                          child: Icon(Icons.settings, color: isDark ? Colors.white : Colors.black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- CONTROLLER GRID ---
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: NeoCard(
                            height: 160,
                            color: AppTheme.hotPink,
                            isButton: true,
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const GameSelectionScreen())
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -20, bottom: -20,
                                  child: Icon(Icons.gamepad, size: 120, color: Colors.white.withValues(alpha: 0.2)),
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
                                        Text("HOST\nGAME", style: textTheme.displayMedium!.copyWith(color: Colors.white, height: 1.1)),
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
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              NeoCard(
                                height: 72,
                                color: AppTheme.cyberYellow,
                                isButton: true,
                                onTap: () => Navigator.pushNamed(context, '/join'),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.login, size: 20, color: Colors.black),
                                      const SizedBox(width: 8),
                                      Text("JOIN", style: textTheme.bodyLarge!.copyWith(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              NeoCard(
                                height: 72,
                                color: Theme.of(context).cardColor,
                                isButton: true,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsManagementScreen())),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.mail_outline, size: 20, color: Theme.of(context).iconTheme.color),
                                          const SizedBox(height: 4),
                                          Text("INBOX", style: textTheme.bodyLarge!.copyWith(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                    if (hasInvites)
                                      Positioned(
                                        right: 0, top: 0,
                                        child: Container(
                                          width: 12, height: 12,
                                          decoration: BoxDecoration(
                                            color: AppTheme.hotPink,
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

                    const SizedBox(height: 30),

                    // --- TABS ---
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: isDark ? Colors.white : Colors.black, offset: const Offset(2, 2))],
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

              // --- CONTENT ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: _currentTab == 0
                      ? _buildFriendsList(friendService, context, consoleColor)
                      : _buildSquadsList(friendService, context),
                ),
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: _currentTab == 1
          ? FloatingActionButton(
        onPressed: () => showDialog(context: context, builder: (_) => const CreateSquadDialog()),
        backgroundColor: isDark ? Colors.white : Colors.black,
        child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
      )
          : null,
    );
  }

  Widget _buildToggleTab(String text, int index, BuildContext context) {
    final isSelected = _currentTab == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? Colors.white : Colors.black;
    final activeText = isDark ? Colors.black : AppTheme.cyberYellow;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pixer',
              fontSize: 16,
              color: isSelected ? activeText : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList(FriendService service, BuildContext context, Color consoleColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    border: Border.all(width: 2, color: isDark ? Colors.white : Colors.black),
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
                          color: friend.isOnline ? AppTheme.matrixGreen : Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSquadsList(FriendService service, BuildContext context) {
    if (service.squads.isEmpty) {
      return const Center(child: Text("NO SQUADS FOUND"));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: service.squads.length,
      itemBuilder: (context, index) {
        final squad = service.squads[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NeoCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(squad.name, style: Theme.of(context).textTheme.bodyLarge),
                    Text("${squad.memberNames.length}/4", style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
                const Divider(thickness: 2, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: squad.memberNames.map((m) => Padding(padding: const EdgeInsets.only(right: 8.0), child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.electricBlue, borderRadius: BorderRadius.circular(4), border: Border.all()), child: Center(child: Text(m.isNotEmpty ? m[0] : "?", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)))))).toList()),
                    GestureDetector(onTap: () => Navigator.pushNamed(context, '/chat', arguments: {'name': squad.name, 'isSquad': true}), child: const Icon(Icons.message, size: 16)),
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