import 'dart:async';
import 'package:flutter/foundation.dart';

// Define the callbacks needed by other screens
typedef SdpSignalCallback = void Function(String peerId, String sdp);
typedef IceCandidateCallback = void Function(String peerId, String candidate);

class SocketService with ChangeNotifier {
  // State
  bool isConnected = false;
  String? currentGameCode;
  String? currentUsername;

  // Callbacks (Used by Guest Lobby & Host Screen)
  SdpSignalCallback? onSdpSignal;
  IceCandidateCallback? onIceCandidate;

  // --- MOCK CONNECTION LOGIC ---
  // Instead of connecting to a real server, we just pretend it worked.

  void connect(String jwtToken, {String? username}) {
    if (isConnected) return;

    print("🔌 MOCK SOCKET: Connecting...");

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      isConnected = true;
      currentUsername = username ?? "User";
      print("✅ MOCK SOCKET: Connected!");
      notifyListeners();
    });
  }

  void connectIfNeeded() {
    if (!isConnected) {
      connect("mock_token_123");
    }
  }

  void setGameCode(String gameCode) {
    currentGameCode = gameCode;
    print("🎮 MOCK SOCKET: Joined Lobby $gameCode");
  }

  // --- MOCK SENDING METHODS ---
  // These prevent the app from crashing when you tap buttons.

  void sendInput(String input) {
    print("🕹️ MOCK INPUT SENT: $input");
  }

  void sendSdpSignal(String peerId, String sdp) {
    print("📡 MOCK WEBRTC: SDP Signal sent to $peerId");
  }

  void sendIceCandidate(String peerId, String candidate) {
    print("❄️ MOCK WEBRTC: ICE Candidate sent to $peerId");
  }

  void disconnect() {
    isConnected = false;
    print("❌ MOCK SOCKET: Disconnected");
    notifyListeners();
  }
}