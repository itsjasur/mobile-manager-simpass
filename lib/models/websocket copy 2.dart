import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'dart:developer' as developer;

class WebSocketModel extends ChangeNotifier {
  WebSocketChannel? _socket;
  int _totalUnreadCount = 0;
  bool _isConnected = false;
  List<dynamic> _chats = [];
  String? _roomId;
  // Timer? _reconnectTimer;

  bool get isConnected => _isConnected;
  int get totalUnreadCount => _totalUnreadCount;
  List<dynamic> get chats => _chats;
  String? get roomId => _roomId;

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    _socket = WebSocketChannel.connect(Uri.parse('${CHATSERVERURL}ws/$accessToken'));
    _isConnected = true;
    notifyListeners();

    _socket!.stream.listen(
      (message) => _catchEmits(message),
      onDone: _onDisconnected,
      onError: (error) => print('WebSocket error: $error'),
    );
  }

  void _catchEmits(dynamic message) {
    print('catch emits called');

    final data = jsonDecode(message);
    developer.log(data.toString());

    if (data['type'] == 'total_count') {
      _totalUnreadCount = data['total_unread_count'];
    } else if (data['type'] == 'chats') {
      _chats = data['chats'];
      _roomId = data['room_id'];
      developer.log(chats.toString());
    } else if (data['type'] == 'new_chat') {
      if (_roomId == data['new_chat']['room_id']) {
        _chats.add(data['new_chat']);
      }
    }

    notifyListeners();
  }

  void _emit(Map<String, dynamic> message) {
    if (_socket != null && _isConnected) {
      _socket!.sink.add(jsonEncode(message));
    }
  }

  void joinRoom(String selectedAgentCode) {
    _emit({
      'action': 'join_room',
      'agentCode': selectedAgentCode,
    });
  }

  void _onDisconnected() {
    _isConnected = false;
    notifyListeners();
    // _attemptReconnect();
  }

  void disconnect() {
    _socket?.sink.close();
    _socket = null;
    _isConnected = false;
    notifyListeners();
  }
}
