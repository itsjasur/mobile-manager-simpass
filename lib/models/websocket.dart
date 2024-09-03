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
  String? _selectedRoomId;
  List _chatRooms = [];

  // Timer? _reconnectTimer;
  // Function? _callback;
  // void setCallback(Function callback) {
  //   _callback = callback;
  // }

  bool get isConnected => _isConnected;
  int get totalUnreadCount => _totalUnreadCount;
  List get chatRooms => _chatRooms;
  List get chats => _chats;
  String? get selectedRoomId => _selectedRoomId;

  Future<void> connect() async {
    if (_socket != null) return;
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    // developer.log(accessToken.toString());

    developer.log('fm token: ' + accessToken.toString());

    _socket = WebSocketChannel.connect(Uri.parse('${CHATSERVERURL}ws/$accessToken'));
    _isConnected = true;

    if (_socket != null) {
      String? fcmToken = prefs.getString('fcmToken');
      if (fcmToken != null) {
        _emit({'action': 'update_fcm_token', 'fcmToken': fcmToken});
      }
      print('fcm token sent to chatserver');
    }

    _socket!.stream.listen(
      (message) => _catchEmits(message),
      onDone: _onDisconnected,
      onError: (error) => developer.log('WebSocket error: $error'),
    );

    notifyListeners();
  }

  void _catchEmits(dynamic message) {
    // print('caught emit');
    // developer.log(message);

    final data = jsonDecode(message);
    // developer.log(data.toString());
    if (data['type'] == 'total_count') {
      _totalUnreadCount = data['total_unread_count'];
      developer.log('total unread count called $_totalUnreadCount');
      //
    }
    if (data['type'] == 'chat_rooms') {
      _chatRooms = data['chat_rooms'];
    }

    if (data['type'] == 'chats') {
      List chatz = data['chats'];
      _chats = chatz.reversed.toList();
      _selectedRoomId = data['room_id'];
      resetRoomUnreadCount();
    }
    if (data['type'] == 'new_chat') {
      developer.log('new chat: ' + message.toString());

      if (_selectedRoomId == data['new_chat']['room_id']) {
        _chats.insert(0, data['new_chat']);
        resetRoomUnreadCount();
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

  void resetRoomUnreadCount() {
    developer.log('reset room count called');
    _emit({
      'action': 'reset_room_unread_count',
      'roomId': _selectedRoomId,
    });
  }

  void sendMessage(String text, List<String> attachmentPaths) {
    _emit({
      'action': 'new_message',
      'text': text,
      'attachmentPaths': attachmentPaths,
      'roomId': _selectedRoomId,
    });
  }

  void _onDisconnected() {
    developer.log('disconneced on _onDisconnected');
    _isConnected = false;
    notifyListeners();
    // _attemptReconnect();
  }

  void disconnect() {
    developer.log('disconneced on disconnect');
    _socket?.sink.close();
    _socket = null;
    _isConnected = false;
    notifyListeners();
  }
}
