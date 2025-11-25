# Syncd-ARCP: Multi-Guest Implementation & Testing Guide

## Overview

The Syncd-ARCP system supports **2-4 simultaneous devices** with flexible player count selection. The Host can choose 2, 3, or 4 players, and the system dynamically configures itself accordingly. This document covers the architecture, implementation details, and testing procedures.

---

## Part 1: Architecture (Multi-Guest 4-Device Setup)

### Key Architectural Changes

#### 1. WebRTC Service Refactoring (`lib/services/webrtc_service.dart`)

**Previous Model:**
- Single peer connection (`_peerConnection`)
- Single data channel (`_dataChannel`)
- Single remote stream (`_remoteStream`)

**New Model:**
- Map of peer connections: `Map<String, RTCPeerConnection> _peerConnections`
- Map of data channels: `Map<String, RTCDataChannel> _dataChannels`
- Map of remote streams: `Map<String, MediaStream> _remoteStreams`
- Single local stream shared across all connections

**Key Methods:**
- `createOfferForPeer(String peerId)` - Creates offer for specific guest
- `createAnswerForPeer(String peerId, String remoteSdp)` - Creates answer for specific guest
- `addIceCandidateForPeer(String peerId, String candidate)` - Adds ICE candidate for specific peer
- `handleRemoteSdpForPeer(String peerId, String remoteSdp)` - Handles remote SDP for specific peer
- `getConnectedPeers()` - Returns list of connected peer IDs
- `getConnectedPeerCount()` - Returns total number of connected peers
- `closePeerConnection(String peerId)` - Closes connection to specific peer

**Signaling Callbacks:**
All callbacks now include `peerId` as first parameter:
```dart
typedef SdpSignalCallback = void Function(String peerId, String sdp);
typedef IceCandidateCallback = void Function(String peerId, String candidate);
typedef DataChannelCallback = void Function(String peerId, RTCDataChannel channel);
typedef RemoteStreamCallback = void Function(String peerId, MediaStream stream);
typedef DataMessageCallback = void Function(String peerId, Map<String, dynamic> data);
```

#### 2. Socket Service Updates (`lib/services/socket_service.dart`)

**Changes:**
- Updated signaling callbacks to use `peerId` instead of `fromUser`
- `sendSdpSignal(String peerId, String sdp)` - Route to specific peer
- `sendIceCandidate(String peerId, String candidate)` - Route to specific peer
- Added fallback support for `fromUser` in callback parsing for backward compatibility

#### 3. Host Screen Enhancement (`lib/screens/host_screen.dart`)

**New Components:**
- `GuestStatus` class - Tracks connection and streaming state per guest
- `guestStatus` Map - Maintains status for each guest slot
- `maxPlayerCount` - Dynamic player count (2-4)
- `gameStarted` - Tracks if player count was selected

**Multi-Guest Streaming:**
```dart
for (final slot in guestStatus.keys) {
    final peerId = guestStatus[slot]!.guestId;
    await webRtcService.createOfferForPeer(peerId, withVideo: true);
}
```

**Status Tracking:**
- `_updateGuestStatus()` - Updates connection/streaming state
- Callbacks from WebRtcService update guest status in real-time

**UI Display:**
- Player grid now shows connection status (cloud icon) and streaming status (LIVE/IDLE)
- Squad counter: "SQUAD (X/maxPlayerCount)"
- Grid layout adapts: 1 column for 2 players, 2 columns for 3-4 players

#### 4. Guest Lobby Screen Updates (`lib/screens/guest_lobby_screen.dart`)

**Changes:**
- WebRtcService initialized with peer-specific callbacks
- `peerId` constructed as `"guest_${widget.playerSlot}"`
- Callbacks properly route to specific peer using `peerId`

#### 5. Join Screen Enhancement (`lib/screens/join_screen.dart`)

**New Features:**
- Converted from `StatelessWidget` to `StatefulWidget`
- Added player slot selector (P1, P2, P3, P4)
- Guest can choose which slot to join
- Selected slot passed to `GuestLobbyScreen(playerSlot: selectedSlot)`

#### 6. Backend Updates

**SdpSignal.java & IceCandidateSignal.java:**
- Added `peerId` field for multi-peer routing
- Maintained `toUser` for backward compatibility

**GameController.java:**
```java
String targetPeerId = signal.getPeerId() != null ? signal.getPeerId() : signal.getToUser();
messagingTemplate.convertAndSendToUser(targetPeerId, "/queue/webrtc/sdp", signal);
```

### Peer Identification Scheme

- **Host:** Uses username "host"
- **Guest 1:** Uses peerId "guest_1"
- **Guest 2:** Uses peerId "guest_2"
- **Guest 3:** Uses peerId "guest_3"

---

## Part 2: Flexible Player Count Implementation

### Player Count Selection

**Host Flow:**
1. App launches → displays "SELECT PLAYERS" screen
2. Host taps 2, 3, or 4
3. System initializes game with selected player count
4. Grid layout adapts accordingly

**Dynamic Slot Initialization:**
```dart
_initializeGuestSlots(int playerCount)
  - Creates playerCount - 1 guest slots
  - 2 players: 1 slot (guest_1)
  - 3 players: 2 slots (guest_1, guest_2)
  - 4 players: 3 slots (guest_1, guest_2, guest_3)
```

### Resource Optimization

| Players | Streams | Bandwidth | Memory |
|---------|---------|-----------|--------|
| 2 | 1 | 2-3 Mbps | 50-100MB |
| 3 | 2 | 4-6 Mbps | 100-200MB |
| 4 | 3 | 6-9 Mbps | 150-300MB |

---

## Part 3: Testing Guide

### Prerequisites

- **4 Android devices** (or emulators)
- **1 Backend server** (`ws://BACKEND_IP:8080/ws-sync/websocket`)
- All devices on same network

### Device Setup

| Device | Role | Player Slot | Function |
|--------|------|-------------|----------|
| Device 1 | Host | P1 | Streams screen, receives taps |
| Device 2 | Guest | P2 | Sees stream, sends taps |
| Device 3 | Guest | P3 | Sees stream, sends taps |
| Device 4 | Guest | P4 | Sees stream, sends taps |

### Testing Workflow

#### Step 1: Start Backend Server

```bash
cd backend
mvn spring-boot:run
```

Verify console output:
```
✅ Started WebSocket listening on port 8080
✅ Message broker configured
```

#### Step 2: Launch Host Device (Device 1)

1. Install and run app: `flutter run --release`
2. Navigate to HOST SCREEN → "HOST A GAME"
3. Select player count (2, 3, or 4)
4. Note the Game Code displayed
5. Verify Accessibility Service enabled (green checkmark)

#### Step 3: Launch Guests (Devices 2-N)

For each guest device:
1. Install and run app: `flutter run --release`
2. Tap "JOIN A GAME"
3. Enter game code from Host
4. **Select Player Slot** (P2, P3, or P4)
5. Tap "CONNECT ->"
6. Verify connection and streaming on Host

#### Step 4: Verify Full Lobby

- Host shows "SQUAD (X/maxPlayerCount)"
- All connected slots display green cloud + "LIVE"
- Connection/streaming status updates in real-time

#### Step 5: Start Streaming

On Host Device:
1. Verify Accessibility Service enabled
2. Tap "START STREAM"
3. All guests should see host screen

#### Step 6: Test Tap Injection

On each guest device:
1. See Host's screen with quadrant overlay
2. Tap on different quadrants
3. Verify Host receives tap at correct coordinates
4. Verify tap is injected by Accessibility Service

### Verification Metrics

#### Connection Metrics
- [ ] Host creates correct number of peer connections (players - 1)
- [ ] Each guest connects within 3-5 seconds
- [ ] WebRTC data channels open for all guests
- [ ] Status indicators update on Host

#### Streaming Metrics
- [ ] Video streams to all guests without lag
- [ ] Video quality sufficient for gameplay (15+ FPS)
- [ ] No stuttering on screen capture

#### Input Metrics
- [ ] Tap latency < 100ms
- [ ] Multiple simultaneous taps handled correctly
- [ ] Correct player slot receives each tap
- [ ] No cross-talk between guests

#### Error Handling
- [ ] Guest disconnect → status changes to grey
- [ ] Guest reconnect → status returns to green
- [ ] Host leaves → guests disconnect gracefully
- [ ] Network delay → system handles gracefully

### Backend Log Inspection

```bash
# View Flutter logs
flutter logs

# View Android logcat
adb logcat | grep "Syncd\|WebRTC\|Socket"

# View backend logs (console output from mvn spring-boot:run)
```

**Key log patterns to look for:**

**Host side:**
```
✅ SOCKET CONNECTED
📡 Data channel opened from guest_2
📹 Remote stream received from guest_2
📍 Tap from guest_2: x=120, y=340
```

**Guest side:**
```
✅ SOCKET CONNECTED
📄 Creating answer for offer
✓ Connection ESTABLISHED
📹 Remote stream connected
```

**Backend:**
```
📤 Routing SDP signal from host to peerId: guest_2
📤 Routing ICE candidate from guest_2 to peerId: host
```

### Performance Benchmarks

Expected performance with proper setup:

| Metric | Expected Value |
|--------|-----------------|
| Connection time per guest | 2-5 seconds |
| First frame latency | 500ms - 2 seconds |
| Tap injection latency | 50-150ms |
| Video bitrate (per stream) | 2-3 Mbps |
| CPU usage (Host) | 40-70% |
| Memory per peer connection | 50-100MB |

### Test Scenarios

**Scenario 1: Sequential Join**
1. Host starts and selects player count
2. Guests join one by one
3. Verify status updates for each

**Scenario 2: Random Tap Injection**
1. All devices connected
2. Guests tap randomly in different quadrants
3. Host receives all taps correctly

**Scenario 3: Simultaneous Taps**
1. All devices connected
2. All guests tap simultaneously
3. Host receives all taps

**Scenario 4: Guest Disconnect/Reconnect**
1. All connected
2. Guest closes app
3. Host shows grey status
4. Guest rejoins → status returns to green

**Scenario 5: Different Player Counts**
1. Test 2-player game
2. Test 3-player game
3. Test 4-player game
4. Verify resource usage adapts

### Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Guest can't connect | Network/backend | Check `ws://BACKEND_IP:8080` is accessible |
| Guest connects but no video | Stream not started | Ensure Host tapped "START STREAM" |
| Tap not injected | Accessibility Service disabled | Enable in Android Settings |
| Multiple guests same slot | Slot not selected | Verify slot selection before connect |
| Slow tap injection | High latency | Check network ping, reduce player count |
| App crash on stream | Resource issue | Check device memory, reduce video bitrate |

---

## Part 4: File Modifications Summary

| File | Changes |
|------|---------|
| `lib/services/webrtc_service.dart` | Multi-peer connection management |
| `lib/services/socket_service.dart` | peerId-based signaling |
| `lib/screens/host_screen.dart` | Player count selection, dynamic slots, guest status tracking |
| `lib/screens/guest_lobby_screen.dart` | peerId-aware signaling |
| `lib/screens/join_screen.dart` | Player slot selector |
| `backend/.../SdpSignal.java` | Added peerId field |
| `backend/.../IceCandidateSignal.java` | Added peerId field |
| `backend/.../GameController.java` | Multi-peer routing logic |

---

## Build Status

✅ **Flutter:** No compilation errors  
✅ **APK Build:** Successful (82.6MB)  
✅ **Analysis:** 43 info-level warnings (non-critical)  
✅ **Backend:** Maven compilation successful  

---

## Next Steps for Production

1. **Coordinate Mapping:** Implement scaling/transformation for different screen sizes
2. **Backend Validation:** Move player count validation to backend for security
3. **Voice Chat:** Integrate WebRTC audio for all participants
4. **Session Management:** Persist room state, allow mid-game joins/leaves
5. **Bandwidth Adaptation:** Implement adaptive bitrate based on network conditions
6. **Error Recovery:** Handle connection failures and reconnection logic
