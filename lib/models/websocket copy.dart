import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class WebSocketModel extends ChangeNotifier {
  WebSocketChannel? _socket;
  bool _isConnected = false;
  int _totalUnreadCount = 0;
  String _connectionStatus = 'Initial';
  List<dynamic> _chats = [];
  String? _roomId;
  Timer? _reconnectTimer;

  bool get isConnected => _isConnected;
  int get totalUnreadCount => _totalUnreadCount;
  String get connectionStatus => _connectionStatus;
  List<dynamic> get chats => _chats;
  String? get roomId => _roomId;

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    final wsUrl = Uri.parse('${CHATSERVERURL}wss/$accessToken');
    _socket = WebSocketChannel.connect(wsUrl);

    _socket!.stream.listen(
      (message) => _handleMessage(message),
      onDone: _onDisconnected,
      onError: (error) => print('WebSocket error: $error'),
    );

    _isConnected = true;
    _connectionStatus = 'Connected';
    _clearReconnectTimer();
    notifyListeners();

    // Update FCM token
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        _sendMessage({
          'action': 'update_fcm_token',
          'fcmToken': fcmToken,
        });
      }
    } catch (e) {
      print('Failed to get FCM token: $e');
    }
  }

  void _handleMessage(dynamic message) {
    final data = jsonDecode(message);

    if (data['type'] == 'total_count') {
      _totalUnreadCount = data['total_unread_count'];
    } else if (data['type'] == 'chats') {
      _chats = data['chats'];
      _roomId = data['room_id'];
    } else if (data['type'] == 'new_chat') {
      if (_roomId == data['new_chat']['room_id']) {
        _chats.add(data['new_chat']);
      }
    }

    notifyListeners();
  }

  void joinRoom(String selectedAgentCode) {
    _sendMessage({
      'action': 'join_room',
      'agentCode': selectedAgentCode,
    });
  }

  void resetRoomUnreadCount() {
    _sendMessage({
      'action': 'reset_room_unread_count',
      'roomId': _roomId,
    });
  }

  void sendMessage(String text, List<String> attachmentPaths) {
    _sendMessage({
      'action': 'new_message',
      'text': text,
      'attachmentPaths': attachmentPaths,
      'roomId': _roomId,
    });
  }

  void _sendMessage(Map<String, dynamic> message) {
    if (_socket != null && _isConnected) {
      _socket!.sink.add(jsonEncode(message));
    }
  }

  void _onDisconnected() {
    _isConnected = false;
    _connectionStatus = 'Disconnected';
    notifyListeners();
    _attemptReconnect();
  }

  void _attemptReconnect() {
    // _clearReconnectTimer();
    // _reconnectTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   print('Attempting to reconnect...');
    //   connect();
    // });
  }

  void _clearReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void disconnect() {
    _clearReconnectTimer();
    if (_socket != null && _isConnected) {
      _sendMessage({'action': 'disconnect'});
      _socket!.sink.close();
    }
    _socket = null;
    _isConnected = false;
    _connectionStatus = 'Disconnected';
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
