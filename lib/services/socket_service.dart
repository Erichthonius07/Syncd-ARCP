import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef SdpSignalCallback = void Function(String peerId, String sdp);
typedef IceCandidateCallback = void Function(String peerId, String candidate);

class SocketService with ChangeNotifier {
  StompClient? _client;
  bool isConnected = false;
  String? currentGameCode;
  String? currentUsername;
  String? _jwtToken;

  SdpSignalCallback? onSdpSignal;
  IceCandidateCallback? onIceCandidate;

  final String _wsUrl = 'ws://10.0.2.2:8080/ws-sync/websocket';

  void connect(String jwtToken, {String? username}) {
    _jwtToken = jwtToken;
    currentUsername = username;
    
    if (_client != null && _client!.connected) {
      print("✅ Already connected to WebSocket");
      return;
    }

    print("🔗 Attempting WebSocket connection to: $_wsUrl");

    _client = StompClient(
      config: StompConfig(
        url: _wsUrl,
        onConnect: (StompFrame frame) {
          isConnected = true;
          print("✅ SOCKET CONNECTED - STOMP negotiation complete");
          _subscribeToGameChannels();
          notifyListeners();
        },
        onDisconnect: (frame) {
          isConnected = false;
          print("❌ SOCKET DISCONNECTED");
          notifyListeners();
        },
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
        stompConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
          'login': 'guest',
          'passcode': 'guest',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $jwtToken',
        },
        beforeConnect: () async {
          print("🔄 Before connect: Preparing STOMP handshake...");
        },
      ),
    );
    _client?.activate();
  }

  void connectIfNeeded() {
    if (_jwtToken != null && (_client == null || !_client!.connected)) {
      connect(_jwtToken!);
    }
  }

  void setGameCode(String gameCode) {
    currentGameCode = gameCode;
    _subscribeToGameChannels();
  }

  void _subscribeToGameChannels() {
    if (!isConnected || currentGameCode == null) return;

    _client?.subscribe(
      destination: '/user/queue/webrtc/sdp',
      callback: (frame) {
        try {
          final data = jsonDecode(frame.body ?? '{}');
          final peerId = data['peerId'] as String? ?? data['fromUser'] as String?;
          final sdp = data['sdp'] as String?;
          if (peerId != null && sdp != null) {
            onSdpSignal?.call(peerId, sdp);
          }
        } catch (e) {
          print('Error parsing SDP signal: $e');
        }
      },
    );

    _client?.subscribe(
      destination: '/user/queue/webrtc/ice',
      callback: (frame) {
        try {
          final data = jsonDecode(frame.body ?? '{}');
          final peerId = data['peerId'] as String? ?? data['fromUser'] as String?;
          final candidate = data['candidate'] as String?;
          if (peerId != null && candidate != null) {
            onIceCandidate?.call(peerId, candidate);
          }
        } catch (e) {
          print('Error parsing ICE candidate: $e');
        }
      },
    );

    _client?.subscribe(
      destination: '/topic/game/$currentGameCode',
      callback: (frame) {
        try {
          final data = jsonDecode(frame.body ?? '{}');
          print('📨 Game event received: $data');
        } catch (e) {
          print('Error parsing game event: $e');
        }
      },
    );
  }

  void sendSdpSignal(String peerId, String sdp) {
    if (!isConnected || currentGameCode == null) return;

    final payload = {
      "gameCode": currentGameCode,
      "peerId": peerId,
      "sdp": sdp,
    };

    _client?.send(
      destination: '/app/game/signal/sdp',
      body: jsonEncode(payload),
    );
    print("📤 SDP Signal Sent to $peerId");
  }

  void sendIceCandidate(String peerId, String candidate) {
    if (!isConnected || currentGameCode == null) return;

    final payload = {
      "gameCode": currentGameCode,
      "peerId": peerId,
      "candidate": candidate,
    };

    _client?.send(
      destination: '/app/game/signal/ice',
      body: jsonEncode(payload),
    );
    print("📤 ICE Candidate Sent to $peerId");
  }

  void sendInput(String input) {
    if (!isConnected || currentGameCode == null) return;

    final payload = {
      "gameCode": currentGameCode,
      "playerSlot": 1,
      "inputData": input
    };

    _client?.send(
      destination: '/app/game/input',
      body: jsonEncode(payload),
    );
    print("📤 Input Sent: $input");
  }

  void disconnect() {
    _client?.deactivate();
    isConnected = false;
    notifyListeners();
  }
}