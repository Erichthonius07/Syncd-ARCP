import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
// Removed unused add_friend_dialog import
import '../services/friend_service.dart';
import '../theme.dart';

class HostScreen extends StatefulWidget {
  final List<String>? initialPlayers;

  const HostScreen({super.key, this.initialPlayers});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  late List<String> players;
  final String gameCode = "SYNC-882";

  @override
  void initState() {
    super.initState();
    players = widget.initialPlayers != null ? List.from(widget.initialPlayers!) : ["You"];
  }

  void _kickPlayer(String name) {
    setState(() {
      players.remove(name);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kicked $name"))
    );
  }

  void _inviteFriend(String name) {
    if (players.length < 4) {
      setState(() {
        players.add(name);
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invited $name"))
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lobby is full!"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);
    // Removed unused 'isDark' variable
    final friendService = Provider.of<FriendService>(context);

    final iconColor = Theme.of(context).iconTheme.color;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    return Scaffold(
      body: DotGridBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, size: 32, color: iconColor),
                    ),
                    const SizedBox(width: 16),
                    Text("LOBBY", style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
                const SizedBox(height: 30),

                // 2. GAME CODE CARD
                Center(
                  child: NeoCard(
                    color: colors.actionLibrary,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          const Text("GAME CODE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(height: 8),
                          Text(
                            gameCode,
                            style: GoogleFonts.spaceGrotesk(fontSize: 42, fontWeight: FontWeight.w900, letterSpacing: 2, color: Colors.black),
                          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 8),

                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(const ClipboardData(text: "SYNC-882"));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Code Copied!"))
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black),
                              ),
                              child: const Text("TAP TO COPY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                Text("SQUAD (${players.length}/4)", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 16),

                // 3. PLAYER GRID
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final isOccupied = index < players.length;
                      final name = isOccupied ? players[index] : "WAITING...";
                      final isMe = name == "You";

                      if (!isOccupied) {
                        return GestureDetector(
                          onTap: () => _showInviteDialog(context, friendService),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, style: BorderStyle.solid, color: colors.outline.withValues(alpha: 0.3)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: colors.outline),
                                  const SizedBox(height: 4),
                                  Text("INVITE", style: TextStyle(fontFamily: 'Pixer', fontSize: 12, color: colors.outline)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      return Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(width: 2, color: colors.outline),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person, size: 32, color: iconColor),
                                const SizedBox(height: 8),
                                Text(
                                    name,
                                    style: TextStyle(fontFamily: 'Pixer', fontSize: 14, color: textColor)
                                ),
                              ],
                            ),
                          ),

                          if (!isMe)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => _kickPlayer(name),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: AppTheme.hotPink,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 1.5)
                                  ),
                                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                NeoCard(
                  color: colors.actionHost,
                  isButton: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Connecting to Game Server..."))
                    );
                  },
                  child: Center(
                    child: Text("START GAME", style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, FriendService service) {
    final colors = AppTheme.c(context);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: NeoCard(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("INVITE FRIEND", style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 20),

              ...service.friends.where((f) => !players.contains(f.name)).map((f) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: NeoCard(
                      color: colors.surface,
                      onTap: () => _inviteFriend(f.name),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(f.name, style: Theme.of(context).textTheme.bodyLarge),
                          Icon(Icons.add_circle_outline, color: colors.accentIcon)
                        ],
                      ),
                    ),
                  )
              ),

              if (service.friends.every((f) => players.contains(f.name)))
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("All friends are here!", style: TextStyle(fontFamily: 'Pixer')),
                ),

              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("CANCEL"),
              )
            ],
          ),
        ),
      ),
    );
  }
}