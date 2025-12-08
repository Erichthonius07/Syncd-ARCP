import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

// Callbacks for WebRTC signaling
typedef SdpSignalCallback = void Function(String peerId, String sdp);
typedef IceCandidateCallback = void Function(String peerId, String candidate);

class SocketService with ChangeNotifier {
  StompClient? _client;
  bool isConnected = false;
  String? currentGameCode;
  String? _jwtToken;

  // Callbacks
  SdpSignalCallback? onSdpSignal;
  IceCandidateCallback? onIceCandidate;

  // ⚠️ CRITICAL: BASE URL LOGIC (Matches AuthService)
  // Uses localhost for Android (via ADB Reverse) or standard localhost for others
  static String get _wsUrl {
    // Note: 'ws' protocol for WebSocket
    if (Platform.isAndroid) {
      return 'ws://localhost:8080/ws-sync/websocket';
    }
    return 'ws://localhost:8080/ws-sync/websocket';
  }

  void connect(String jwtToken) {
    _jwtToken = jwtToken;

    if (_client != null && _client!.connected) {
      print("✅ Already connected to WebSocket");
      return;
    }

    final url = _wsUrl;
    print("🔗 Attempting WebSocket connection to: $url");

    _client = StompClient(
      config: StompConfig.sockJS(
        url: url,
        onConnect: _onConnect,
        onWebSocketError: (dynamic error) {
          isConnected = false;
          print("❌ WS Error: $error");
          notifyListeners();
        },
        onStompError: (StompFrame frame) {
          print("❌ STOMP Error: ${frame.body}");
          isConnected = false;
          notifyListeners();
        },
        onDisconnect: (StompFrame frame) {
          isConnected = false;
          print("❌ SOCKET DISCONNECTED");
          notifyListeners();
        },
        // Send JWT in headers for the backend interceptor
        stompConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
        webSocketConnectHeaders: {'Authorization': 'Bearer $jwtToken'},
        beforeConnect: () async {
          print("🔄 Before connect: Preparing STOMP handshake...");
        },
      ),
    );

    _client?.activate();
  }

  void _onConnect(StompFrame frame) {
    isConnected = true;
    print("✅ SOCKET CONNECTED - STOMP negotiation complete");

    // Subscribe to personal queue for signaling/chat
    _client?.subscribe(
      destination: '/user/queue/webrtc/sdp',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          // Assuming data structure: { "fromUser": "...", "sdp": "..." }
          onSdpSignal?.call(data['fromUser'], data['sdp']);
        }
      },
    );

    _client?.subscribe(
      destination: '/user/queue/webrtc/ice',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          // Assuming data structure: { "fromUser": "...", "candidate": "..." }
          onIceCandidate?.call(data['fromUser'], data['candidate']);
        }
      },
    );

    notifyListeners();
  }

  // Auto-connect helper
  void connectIfNeeded() {
    if (_jwtToken != null && !isConnected) {
      connect(_jwtToken!);
    } else if (_jwtToken == null) {
      print("⚠️ Cannot connect: No token available. Login first.");
    }
  }

  void setGameCode(String gameCode) {
    currentGameCode = gameCode;
    // Subscribe to game topic
    _client?.subscribe(
        destination: '/topic/game/$gameCode',
        callback: (frame) {
          print("🎮 Game Update: ${frame.body}");
        }
    );
  }

  // --- SENDING METHODS ---

  void sendInput(String input) {
    if (!isConnected || currentGameCode == null) return;

    final payload = {
      "gameCode": currentGameCode,
      "playerSlot": 1, // Default slot, should be dynamic in real game
      "inputData": input
    };

    _client?.send(
      destination: '/app/game/input',
      body: jsonEncode(payload),
    );
    // print("📤 Input Sent: $input"); // Comment out to reduce spam
  }

  void sendSdpSignal(String peerId, String sdp) {
    if (!isConnected) return;

    // Matches backend SdpSignal DTO
    final payload = {
      "toUser": peerId,
      "sdp": sdp
    };

    _client?.send(
      destination: '/app/game/signal/sdp',
      body: jsonEncode(payload),
    );
    print("📡 SDP Signal sent to $peerId");
  }

  void sendIceCandidate(String peerId, String candidate) {
    if (!isConnected) return;

    // Matches backend IceCandidateSignal DTO
    final payload = {
      "toUser": peerId,
      "candidate": candidate
    };

    _client?.send(
      destination: '/app/game/signal/ice',
      body: jsonEncode(payload),
    );
    print("❄️ ICE Candidate sent to $peerId");
  }

  void disconnect() {
    _client?.deactivate();
    isConnected = false;
    notifyListeners();
  }
}