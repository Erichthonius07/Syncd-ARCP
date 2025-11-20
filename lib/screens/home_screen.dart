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

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => const MainMenuDialog()),
                          child: Container(
                            width: 50, height: 50,
                            decoration: BoxDecoration(color: AppTheme.electricBlue, border: Border.all(width: 2), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))]),
                            child: Center(child: Text(friendService.currentUserAvatar, style: const TextStyle(fontSize: 28))),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(friendService.currentUserName, style: AppTheme.textTheme.displayMedium!.copyWith(fontSize: 22), overflow: TextOverflow.ellipsis),
                              Row(
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.matrixGreen, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Text("ONLINE", style: AppTheme.textTheme.labelSmall!.copyWith(color: Colors.black)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        NeoCard(
                          onTap: () => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => const MainMenuDialog()),
                          color: AppTheme.consoleGrey,
                          child: const Icon(Icons.settings, color: Colors.black),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // SEARCH BAR FIX
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Search coming in v2.0"))),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(width: 2), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)]),
                        child: Row(
                          children: [
                            const Icon(Icons.search),
                            const SizedBox(width: 10),
                            Text("Search games...", style: AppTheme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: NeoCard(
                            height: 160, color: AppTheme.hotPink, isButton: true,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameSelectionScreen())),
                            child: Stack(
                              children: [
                                Positioned(right: -20, bottom: -20, child: Icon(Icons.gamepad, size: 120, color: Colors.white.withValues(alpha: 0.2))),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)), child: const Text("START", style: TextStyle(color: Colors.white, fontFamily: 'Pixer', fontSize: 12))),
                                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("HOST\nGAME", style: AppTheme.textTheme.displayMedium!.copyWith(color: Colors.white, height: 1.1)), const Icon(Icons.play_arrow_rounded, size: 40, color: Colors.white)]),
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
                              NeoCard(height: 72, color: AppTheme.cyberYellow, isButton: true, onTap: () => Navigator.pushNamed(context, '/join'), child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.login, size: 20), const SizedBox(width: 8), Text("JOIN", style: AppTheme.textTheme.bodyLarge)]))),
                              const SizedBox(height: 16),
                              NeoCard(height: 72, color: Colors.white, isButton: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FriendsManagementScreen())), child: Stack(children: [Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.mail_outline, size: 20), const SizedBox(height: 4), Text("INBOX", style: AppTheme.textTheme.bodyLarge!.copyWith(fontSize: 14))])), if (hasInvites) Positioned(right: 0, top: 0, child: Container(width: 12, height: 12, decoration: BoxDecoration(color: AppTheme.hotPink, shape: BoxShape.circle, border: Border.all(width: 2))))])),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 2), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))]),
                      child: Row(children: [_buildToggleTab("FRIENDS", 0), _buildToggleTab("SQUADS", 1)]),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0), child: _currentTab == 0 ? _buildFriendsList(friendService) : _buildSquadsList(friendService, context))),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentTab == 1 ? FloatingActionButton(onPressed: () => showDialog(context: context, builder: (_) => const CreateSquadDialog()), backgroundColor: Colors.black, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12)), side: BorderSide(color: Colors.white, width: 2)), child: const Icon(Icons.add, color: Colors.white)) : null,
    );
  }

  Widget _buildToggleTab(String text, int index) {
    final isSelected = _currentTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Pixer', fontSize: 16, color: isSelected ? AppTheme.cyberYellow : Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildFriendsList(FriendService service) {
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
                Container(width: 45, height: 45, decoration: BoxDecoration(color: AppTheme.consoleGrey, borderRadius: BorderRadius.circular(8), border: Border.all(width: 2)), child: Center(child: Text(friend.avatar, style: const TextStyle(fontSize: 24)))),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(friend.name, style: AppTheme.textTheme.bodyLarge), Text(friend.isOnline ? "ONLINE" : "OFFLINE", style: TextStyle(color: friend.isOnline ? AppTheme.matrixGreen : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))]),
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
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.groups_2_outlined, size: 64, color: Colors.grey), const SizedBox(height: 16), Text("NO SQUADS FOUND", style: AppTheme.textTheme.displaySmall!.copyWith(color: Colors.grey)), const SizedBox(height: 8), const Text("Tap + to create a team", style: TextStyle(color: Colors.grey))]));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: service.squads.length,
      itemBuilder: (context, index) {
        final squad = service.squads[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: NeoCard(
            color: Colors.white,
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(squad.name, style: AppTheme.textTheme.bodyLarge), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)), child: Text("${squad.memberNames.length}/4", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)))]),
                const Divider(thickness: 2, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: squad.memberNames.map((m) => Padding(padding: const EdgeInsets.only(right: 8.0), child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppTheme.electricBlue, borderRadius: BorderRadius.circular(4), border: Border.all()), child: Center(child: Text(m.isNotEmpty ? m[0] : "?", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))))).toList()),
                    // SQUAD ACTION BUTTONS FIX
                    Row(
                      children: [
                        GestureDetector(onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Squad Settings"))), child: const Icon(Icons.settings, size: 20, color: Colors.grey)),
                        const SizedBox(width: 12),
                        GestureDetector(onTap: () => Navigator.pushNamed(context, '/chat', arguments: squad.name), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: AppTheme.matrixGreen, borderRadius: BorderRadius.circular(4), border: Border.all()), child: const Icon(Icons.message, size: 16))),
                      ],
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