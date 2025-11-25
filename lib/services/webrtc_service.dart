import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef SdpSignalCallback = void Function(String peerId, String sdp);
typedef IceCandidateCallback = void Function(String peerId, String candidate);
typedef DataChannelCallback = void Function(String peerId, RTCDataChannel channel);
typedef RemoteStreamCallback = void Function(String peerId, MediaStream stream);
typedef DataMessageCallback = void Function(String peerId, Map<String, dynamic> data);

class WebRtcService with ChangeNotifier {
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, RTCDataChannel> _dataChannels = {};
  final Map<String, MediaStream> _remoteStreams = {};
  
  MediaStream? _localStream;

  final String Function() getGameCode;
  final String Function() getUsername;
  final SdpSignalCallback onSdpSignal;
  final IceCandidateCallback onIceCandidate;
  final DataChannelCallback onDataChannel;
  final RemoteStreamCallback onRemoteStream;
  final DataMessageCallback? onDataMessage;

  bool isInitialized = false;
  bool isVideoEnabled = false;
  bool isAudioEnabled = false;

  WebRtcService({
    required this.getGameCode,
    required this.getUsername,
    required this.onSdpSignal,
    required this.onIceCandidate,
    required this.onDataChannel,
    required this.onRemoteStream,
    this.onDataMessage,
  });

  Future<void> initialize() async {
    isInitialized = true;
    notifyListeners();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {
          'url': ['stun:stun.l.google.com:19302', 'stun:stun1.l.google.com:19302']
        }
      ]
    };

    return await createPeerConnection(configuration, {
      'mandatory': {},
      'optional': [
        {'DtlsSrtpKeyAgreement': true},
      ]
    });
  }

  Future<void> createOfferForPeer(String peerId, {
    bool withVideo = true,
    bool withAudio = false,
  }) async {
    if (!isInitialized) await initialize();

    if (_peerConnections.containsKey(peerId)) {
      print('⚠️ Peer connection for $peerId already exists');
      return;
    }

    final peerConnection = await _createPeerConnection();
    _peerConnections[peerId] = peerConnection;

    if (withVideo || withAudio) {
      if (_localStream == null) {
        _localStream = await navigator.mediaDevices.getUserMedia({
          'audio': withAudio,
          'video': withVideo
              ? {'mandatory': {}, 'optional': []}
              : false,
        });
      }

      peerConnection.addStream(_localStream!);
      isVideoEnabled = withVideo;
      isAudioEnabled = withAudio;
    }

    peerConnection.onAddStream = (stream) {
      _remoteStreams[peerId] = stream;
      onRemoteStream(peerId, stream);
      notifyListeners();
    };

    peerConnection.onRemoveStream = (stream) {
      _remoteStreams.remove(peerId);
      notifyListeners();
    };

    peerConnection.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        onIceCandidate(peerId, candidate.candidate!);
      }
    };

    peerConnection.onDataChannel = (channel) {
      _dataChannels[peerId] = channel;
      _setupDataChannelListeners(peerId, channel);
      onDataChannel(peerId, channel);
    };

    final dataChannel = await peerConnection.createDataChannel(
      'game-input',
      RTCDataChannelInit()..ordered = true,
    );
    _dataChannels[peerId] = dataChannel;
    _setupDataChannelListeners(peerId, dataChannel);

    final offer = await peerConnection.createOffer({});
    await peerConnection.setLocalDescription(offer);

    onSdpSignal(peerId, offer.sdp ?? '');
  }

  Future<void> createAnswerForPeer(String peerId, String remoteSdp) async {
    if (!isInitialized) await initialize();

    if (_peerConnections.containsKey(peerId)) {
      print('⚠️ Peer connection for $peerId already exists');
      return;
    }

    final peerConnection = await _createPeerConnection();
    _peerConnections[peerId] = peerConnection;

    peerConnection.onAddStream = (stream) {
      _remoteStreams[peerId] = stream;
      onRemoteStream(peerId, stream);
      notifyListeners();
    };

    peerConnection.onRemoveStream = (stream) {
      _remoteStreams.remove(peerId);
      notifyListeners();
    };

    peerConnection.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        onIceCandidate(peerId, candidate.candidate!);
      }
    };

    peerConnection.onDataChannel = (channel) {
      _dataChannels[peerId] = channel;
      _setupDataChannelListeners(peerId, channel);
      onDataChannel(peerId, channel);
    };

    final remoteDescription = RTCSessionDescription(remoteSdp, 'offer');
    await peerConnection.setRemoteDescription(remoteDescription);

    final answer = await peerConnection.createAnswer({});
    await peerConnection.setLocalDescription(answer);

    onSdpSignal(peerId, answer.sdp ?? '');
  }

  Future<void> addIceCandidateForPeer(String peerId, String candidate, int? sdpMLineIndex) async {
    final peerConnection = _peerConnections[peerId];
    if (peerConnection == null) {
      print('❌ No peer connection found for $peerId');
      return;
    }

    try {
      await peerConnection.addCandidate(
        RTCIceCandidate(candidate, 'video', sdpMLineIndex ?? 0),
      );
    } catch (e) {
      print('Error adding ICE candidate for $peerId: $e');
    }
  }

  Future<void> handleRemoteSdpForPeer(String peerId, String remoteSdp) async {
    final peerConnection = _peerConnections[peerId];
    if (peerConnection == null) {
      print('❌ No peer connection found for $peerId');
      return;
    }

    try {
      final remoteDescription = RTCSessionDescription(remoteSdp, 'answer');
      await peerConnection.setRemoteDescription(remoteDescription);
    } catch (e) {
      print('Error setting remote description for $peerId: $e');
    }
  }

  void sendGameInput(String inputData, int playerSlot, String peerId) {
    final dataChannel = _dataChannels[peerId];
    if (dataChannel != null && dataChannel.state == RTCDataChannelState.RTCDataChannelOpen) {
      final message = {
        'type': 'INPUT',
        'playerSlot': playerSlot,
        'inputData': inputData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
      dataChannel.send(RTCDataChannelMessage(jsonEncode(message)));
    }
  }

  void sendTapCoordinate(int x, int y, int playerSlot, {String? peerId}) {
    final targetPeerId = peerId ?? (getUsername().startsWith('host') ? null : 'host');
    
    if (targetPeerId == null) {
      for (final dataChannel in _dataChannels.values) {
        if (dataChannel.state == RTCDataChannelState.RTCDataChannelOpen) {
          final message = {
            'type': 'TAP',
            'x': x,
            'y': y,
            'playerSlot': playerSlot,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          };
          dataChannel.send(RTCDataChannelMessage(jsonEncode(message)));
        }
      }
    } else {
      final dataChannel = _dataChannels[targetPeerId];
      if (dataChannel != null && dataChannel.state == RTCDataChannelState.RTCDataChannelOpen) {
        final message = {
          'type': 'TAP',
          'x': x,
          'y': y,
          'playerSlot': playerSlot,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        dataChannel.send(RTCDataChannelMessage(jsonEncode(message)));
      }
    }
  }

  void _setupDataChannelListeners(String peerId, RTCDataChannel dataChannel) {
    dataChannel.onMessage = (RTCDataChannelMessage message) {
      try {
        final data = jsonDecode(message.text);
        print('📨 Data from $peerId: $data');
        onDataMessage?.call(peerId, data);
      } catch (e) {
        print('Error parsing data channel message from $peerId: $e');
      }
    };

    dataChannel.onDataChannelState = (RTCDataChannelState state) {
      print('🔌 Data Channel State for $peerId: $state');
      notifyListeners();
    };
  }

  MediaStream? getLocalStream() => _localStream;
  MediaStream? getRemoteStream(String peerId) => _remoteStreams[peerId];
  RTCDataChannel? getDataChannel(String peerId) => _dataChannels[peerId];
  bool isDataChannelOpen(String peerId) => _dataChannels[peerId]?.state == RTCDataChannelState.RTCDataChannelOpen;
  
  List<String> getConnectedPeers() => _peerConnections.keys.toList();
  int getConnectedPeerCount() => _peerConnections.length;

  Future<void> closePeerConnection(String peerId) async {
    final peerConnection = _peerConnections[peerId];
    if (peerConnection != null) {
      await peerConnection.close();
      _peerConnections.remove(peerId);
      _dataChannels.remove(peerId);
      _remoteStreams.remove(peerId);
      notifyListeners();
    }
  }

  @override
  Future<void> dispose() async {
    for (final connection in _peerConnections.values) {
      await connection.close();
    }
    _peerConnections.clear();
    _dataChannels.clear();
    _remoteStreams.clear();
    
    await _localStream?.dispose();
    isInitialized = false;
    super.dispose();
  }
}
