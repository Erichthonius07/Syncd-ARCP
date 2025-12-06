import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../services/friend_service.dart';
import '../services/socket_service.dart';
import '../services/webrtc_service.dart';
import '../services/accessibility_service.dart';
import '../theme.dart';

class HostScreen extends StatefulWidget {
  final List<String>? initialPlayers;
  final String? gameCode;

  const HostScreen({super.key, this.initialPlayers, this.gameCode});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class GuestStatus {
  final int playerSlot;
  final String guestId;
  bool isConnected;
  bool isStreaming;

  GuestStatus({
    required this.playerSlot,
    required this.guestId,
    this.isConnected = false,
    this.isStreaming = false,
  });
}

class _HostScreenState extends State<HostScreen> {
  late List<String> players;
  late String gameCode;
  late WebRtcService webRtcService;
  late SocketService socketService;

  bool isStreamingActive = false;
  bool isAccessibilityEnabled = false;
  String connectionStatus = "CONNECTING...";

  int maxPlayerCount = 2;
  bool gameStarted = false;

  final Map<int, GuestStatus> guestStatus = {};

  @override
  void initState() {
    super.initState();
    players = widget.initialPlayers != null ? List.from(widget.initialPlayers!) : ["You"];
    gameCode = widget.gameCode ?? "SYNC-882";

    socketService = Provider.of<SocketService>(context, listen: false);

    webRtcService = WebRtcService(
      getGameCode: () => gameCode,
      getUsername: () => "host",
      onSdpSignal: (peerId, sdp) => socketService.sendSdpSignal(peerId, sdp),
      onIceCandidate: (peerId, candidate) => socketService.sendIceCandidate(peerId, candidate),
      onDataChannel: (peerId, channel) {
        print('📡 Data channel opened from $peerId');
        _updateGuestStatus(peerId, connected: true);
      },
      onRemoteStream: (peerId, stream) {
        print('📹 Remote stream received from $peerId');
        _updateGuestStatus(peerId, streaming: true);
      },
      onDataMessage: _handleDataMessage,
    );

    socketService.onSdpSignal = (peerId, sdp) {
      webRtcService.handleRemoteSdpForPeer(peerId, sdp);
    };

    socketService.onIceCandidate = (peerId, candidate) {
      webRtcService.addIceCandidateForPeer(peerId, candidate, null);
    };

    _initializeStreaming();
    _checkAccessibilityPermission();

    // If players were passed initially (e.g. from Squads), start game immediately
    if (widget.initialPlayers != null) {
      _startGame(4); // Default to 4 for squads
    }
  }

  void _initializeGuestSlots(int playerCount) {
    guestStatus.clear();
    // Guests are player 2, 3, 4 etc.
    int guestCount = playerCount - 1;

    for (int i = 1; i <= guestCount; i++) {
      guestStatus[i] = GuestStatus(
        playerSlot: i,
        guestId: 'guest_$i',
      );
    }
  }

  void _startGame(int playerCount) {
    setState(() {
      maxPlayerCount = playerCount;
      gameStarted = true;
    });
    _initializeGuestSlots(playerCount);
  }

  void _updateGuestStatus(String peerId, {bool? connected, bool? streaming}) {
    final slotNum = int.tryParse(peerId.split('_').last) ?? 0;
    if (slotNum > 0 && slotNum < maxPlayerCount && guestStatus.containsKey(slotNum)) {
      setState(() {
        if (connected != null) guestStatus[slotNum]!.isConnected = connected;
        if (streaming != null) guestStatus[slotNum]!.isStreaming = streaming;
      });
    }
  }

  Future<void> _initializeStreaming() async {
    try {
      socketService.setGameCode(gameCode);
      await webRtcService.initialize();
      setState(() {
        connectionStatus = "INITIALIZED";
      });
    } catch (e) {
      print('Error initializing streaming: $e');
      setState(() {
        connectionStatus = "ERROR";
      });
    }
  }

  Future<void> _checkAccessibilityPermission() async {
    final enabled = await AccessibilityService.isAccessibilityServiceEnabled();
    setState(() {
      isAccessibilityEnabled = enabled;
    });
  }

  void _handleDataMessage(String peerId, Map<String, dynamic> message) async {
    final type = message['type'];

    if (type == 'TAP') {
      final x = (message['x'] as num).toDouble();
      final y = (message['y'] as num).toDouble();
      final playerSlot = message['playerSlot'] as int?;

      print('📍 Tap from $peerId: x=$x, y=$y, player=$playerSlot');

      try {
        await AccessibilityService.performTap(x, y);
      } catch (e) {
        print('❌ Error injecting tap: $e');
      }
    } else if (type == 'INPUT') {
      final inputData = message['inputData'] as String?;
      print('🎮 Input from $peerId: $inputData');
    }
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
    if (players.length < maxPlayerCount) {
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

  Future<void> _startStreaming() async {
    if (!isAccessibilityEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enable Accessibility Service to stream"))
      );
      return;
    }

    try {
      await AccessibilityService.startScreenCapture();
      await Future.delayed(const Duration(milliseconds: 500));

      for (final slot in guestStatus.keys) {
        final peerId = guestStatus[slot]!.guestId;
        print('🎬 Creating offer for guest slot $slot (peerId: $peerId)');
        await webRtcService.createOfferForPeer(peerId, withVideo: true, withAudio: false);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      setState(() {
        isStreamingActive = true;
        connectionStatus = "STREAMING";
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Stream Started for all guests!"))
      );
    } catch (e) {
      print('Error starting stream: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
      );
    }
  }

  @override
  void dispose() {
    webRtcService.dispose();
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.c(context);
    final friendService = Provider.of<FriendService>(context);
    final iconColor = Theme.of(context).iconTheme.color;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color;

    // --- VIEW 1: SELECT PLAYER COUNT ---
    if (!gameStarted) {
      return Scaffold(
        body: DotGridBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, size: 32, color: iconColor),
                  ),
                  const Spacer(),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SELECT PLAYERS", style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 32),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 1.2,
                          children: [2, 3, 4].map((count) {
                            // FIX: Moved onTap inside NeoCard
                            return NeoCard(
                              color: colors.success,
                              isButton: true,
                              onTap: () => _startGame(count), // <--- Clickable area fixed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "$count",
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    count == 2 ? "PLAYERS" : "PLAYERS",
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black54),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // --- VIEW 2: LOBBY ---
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
                Text("SQUAD (${players.length}/$maxPlayerCount)", style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 16),

                // 3. PLAYER GRID
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: maxPlayerCount <= 2 ? 1 : 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3
                    ),
                    itemCount: maxPlayerCount,
                    itemBuilder: (context, index) {
                      final slotNum = index + 1;
                      final isOccupied = index < players.length;
                      final name = isOccupied ? players[index] : "WAITING...";
                      final isMe = name == "You";
                      // Only check guest status for slots > 1 (Host is slot 1)
                      final status = slotNum > 1 ? guestStatus[slotNum] : null;

                      if (!isOccupied) {
                        // --- EMPTY SLOT (INVITE BUTTON) ---
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

                      // --- FILLED SLOT ---
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
                                const SizedBox(height: 4),
                                if (status != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        status.isConnected ? Icons.cloud_done : Icons.cloud_off,
                                        size: 12,
                                        color: status.isConnected ? AppTheme.matrixGreen : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        status.isStreaming ? "LIVE" : "IDLE",
                                        style: TextStyle(
                                          fontFamily: 'Pixer',
                                          fontSize: 10,
                                          color: status.isStreaming ? AppTheme.matrixGreen : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),

                          // Kick Button (Red X)
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

                // 4. START STREAM BUTTON
                Row(
                  children: [
                    Expanded(
                      child: NeoCard(
                        color: colors.actionHost,
                        isButton: true,
                        onTap: isAccessibilityEnabled ? _startStreaming : null,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isStreamingActive ? "STREAMING" : "START STREAM",
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                connectionStatus,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    NeoCard(
                      color: isAccessibilityEnabled ? AppTheme.matrixGreen : AppTheme.hotPink,
                      isButton: true,
                      onTap: _checkAccessibilityPermission,
                      child: Icon(
                        isAccessibilityEnabled ? Icons.check : Icons.warning,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ... [_showInviteDialog] remains the same ...
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