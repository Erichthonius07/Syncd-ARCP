import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class SocketService with ChangeNotifier {
  StompClient? _client;
  bool isConnected = false;
  String? currentGameCode;
  String? _jwtToken; // Store JWT token for reconnection

  // WebSocket URL pointing to the Spring WebSocket endpoint
  final String _wsUrl = 'ws://10.0.2.2:8080/ws-sync/websocket';

  void connect(String jwtToken) {
    _jwtToken = jwtToken; // Store token for reconnection
    
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
        heartbeat: const StompFrame.heartbeat(),
        beforeConnect: () async {
          print("🔄 Before connect: Preparing STOMP handshake...");
        },
      ),
    );
    _client?.activate();
  }

  // Auto-connect using stored token (for when navigating to ControllerScreen)
  void connectIfNeeded() {
    if (_jwtToken != null && (_client == null || !_client!.connected)) {
      connect(_jwtToken!);
    }
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
}