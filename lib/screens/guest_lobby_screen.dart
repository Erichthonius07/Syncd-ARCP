import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../widgets/dot_grid_background.dart';
import '../widgets/neo_card.dart';
import '../services/socket_service.dart';
import '../services/webrtc_service.dart';
import '../theme.dart';

class GuestLobbyScreen extends StatefulWidget {
  final String lobbyCode;
  final int playerSlot;

  const GuestLobbyScreen({
    super.key,
    required this.lobbyCode,
    this.playerSlot = 1,
  });

  @override
  State<GuestLobbyScreen> createState() => _GuestLobbyScreenState();
}

class _GuestLobbyScreenState extends State<GuestLobbyScreen> {
  late WebRtcService webRtcService;
  late SocketService socketService;
  
  bool isConnected = false;
  bool isStreaming = false;
  MediaStream? remoteStream;
  RTCVideoRenderer? videoRenderer;

  @override
  void initState() {
    super.initState();
    socketService = Provider.of<SocketService>(context, listen: false);
    videoRenderer = RTCVideoRenderer();
    
    final peerId = "guest_${widget.playerSlot}";
    
    webRtcService = WebRtcService(
      getGameCode: () => widget.lobbyCode,
      getUsername: () => peerId,
      onSdpSignal: (peerId, sdp) => socketService.sendSdpSignal(peerId, sdp),
      onIceCandidate: (peerId, candidate) => socketService.sendIceCandidate(peerId, candidate),
      onDataChannel: (peerId, channel) {
        print('📡 Data channel opened for $peerId');
      },
      onRemoteStream: (peerId, stream) {
        setState(() {
          remoteStream = stream;
          isStreaming = true;
        });
      },
      onDataMessage: null,
    );
    
    socketService.onSdpSignal = (peerId, sdp) {
      if (sdp.contains('offer')) {
        webRtcService.createAnswerForPeer(peerId, sdp);
      } else {
        webRtcService.handleRemoteSdpForPeer(peerId, sdp);
      }
    };
    
    socketService.onIceCandidate = (peerId, candidate) {
      webRtcService.addIceCandidateForPeer(peerId, candidate, null);
    };
    
    _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    try {
      socketService.setGameCode(widget.lobbyCode);
      await webRtcService.initialize();
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      print('Error initializing connection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection Error: $e')),
        );
      }
    }
  }

  void _onTouchDown(TapDownDetails details, int quadrant) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final tapPosition = details.localPosition;
    
    webRtcService.sendTapCoordinate(
      tapPosition.dx.toInt(),
      tapPosition.dy.toInt(),
      quadrant,
    );
  }

  @override
  void dispose() {
    videoRenderer?.dispose();
    webRtcService.dispose();
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          if (remoteStream != null && isStreaming && videoRenderer != null)
            FutureBuilder(
              future: videoRenderer!.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return FutureBuilder(
                    future: Future.delayed(Duration.zero, () async {
                      videoRenderer!.srcObject = remoteStream;
                      return true;
                    }),
                    builder: (context, asyncSnapshot) {
                      return RTCVideoView(
                        videoRenderer!,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      );
                    },
                  );
                }
                return Center(
                  child: CircularProgressIndicator().animate().fadeIn(),
                );
              },
            )
          else
            DotGridBackground(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator().animate().fadeIn(),
                    const SizedBox(height: 24),
                    Text(
                      isConnected ? "Waiting for stream..." : "Connecting...",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PLAYER ${widget.playerSlot}", style: Theme.of(context).textTheme.labelSmall),
                          Text(
                            isStreaming ? "LIVE" : "WAITING",
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: isStreaming ? AppTheme.matrixGreen : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      NeoCard(
                        onTap: () => Navigator.pop(context),
                        color: AppTheme.hotPink,
                        child: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isStreaming)
            Positioned.fill(
              top: kToolbarHeight + 32,
              child: _buildQuadrantController(screenSize),
            ),
        ],
      ),
    );
  }

  Widget _buildQuadrantController(Size screenSize) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) => _onTouchDown(details, 1),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.1),
                    child: const Center(
                      child: Text(
                        "P1",
                        style: TextStyle(color: Colors.white70, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) => _onTouchDown(details, 3),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.2),
                    child: const Center(
                      child: Text(
                        "P3",
                        style: TextStyle(color: Colors.white70, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) => _onTouchDown(details, 2),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.15),
                    child: const Center(
                      child: Text(
                        "P2",
                        style: TextStyle(color: Colors.white70, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) => _onTouchDown(details, 4),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.25),
                    child: const Center(
                      child: Text(
                        "P4",
                        style: TextStyle(color: Colors.white70, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
