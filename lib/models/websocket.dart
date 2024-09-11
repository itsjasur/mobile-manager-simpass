import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'dart:developer' as developer;

class WebSocketModel extends ChangeNotifier {
  WebSocketChannel? _socket;
  int _totalUnreadCount = 0;
  bool _isConnected = false;
  List<dynamic> _chats = [];

  List _chatRooms = [];
  String? _myUsername;
  Map? _selectedRoom;

  bool get isConnected => _isConnected;
  int get totalUnreadCount => _totalUnreadCount;
  List get chatRooms => _chatRooms;
  List get chats => _chats;
  String? get myUsername => _myUsername;
  Map? get selectedRoom => _selectedRoom;

  Timer? _reconnectTimer;

  void setUsername(String username) {
    _myUsername = username;
    notifyListeners();
  }

  void selectRoom(Map? room) {
    _selectedRoom = room;
    notifyListeners();
  }

  void setChatRooms(List rooms) {
    _chatRooms = rooms;
    notifyListeners();
  }

  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (_socket == null) {
      // developer.log(accessToken.toString());
      _socket = WebSocketChannel.connect(Uri.parse('${CHATSERVERURL}ws/$accessToken'));
      // _socket = WebSocketChannel.connect(Uri.parse('${CHATSERVERURL}ws/asdaskldjlaksjdl;kas'));
      _isConnected = true;
    }

    if (_socket != null) {
      String? fcmToken = prefs.getString('fcmToken');
      if (fcmToken != null) {
        _emit({'action': 'update_fcm_token', 'fcmToken': fcmToken});
        // print('fcm token sent to chatserver');
      }
    }

    _socket!.stream.listen(
      (message) => _catchEmits(message),
      onDone: _onDisconnected,
      onError: (error) => developer.log('WebSocket error: $error'),
    );

    _reconnectTimer?.cancel();
    notifyListeners();
  }

  void _catchEmits(dynamic message) {
    // print('caught emit');
    final data = jsonDecode(message);
    // developer.log(data.toString());
    if (data['type'] == 'total_count') {
      _totalUnreadCount = data?['total_unread_count'] ?? 0;
      developer.log('total unread count called $_totalUnreadCount');
      //
    }
    if (data['type'] == 'chat_rooms') {
      for (Map room in data['rooms'] ?? []) {
        for (int i = 0; i < _chatRooms.length; i++) {
          if (room['agent_code'] == _chatRooms[i]['agent_code']) {
            _chatRooms[i] = {..._chatRooms[i], ...room};
          }
        }
      }
    }

    if (data['type'] == 'room_chats') {
      // room_info will come when user joins new room
      if (data?['room_info'] != null) {
        _selectedRoom = {...(_selectedRoom ?? {}), ...data['room_info']};
      }

      List chatz = data['chats'];
      _chats = chatz.reversed.toList();
      resetRoomUnreadCount();
    }

    if (data?['type'] == 'room_modified') {
      Map? modifiedRoom = data?['modified_room'];
      final index = _chatRooms.indexWhere((room) => room['room_id'] == modifiedRoom?['room_id']);
      if (index != -1) {
        _chatRooms[index] = {
          ...(_chatRooms[index] ?? {}),
          ...(modifiedRoom ?? {}),
        };
      }
    }

    if (data['type'] == 'new_chat') {
      if (_selectedRoom?['room_id'] == data['new_chat']['room_id']) {
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

  void joinNewRoom(String agentCode) {
    _emit({
      'action': 'join_new_room',
      'agentCode': agentCode,
    });
  }

  void getChatRooms() {
    _emit({
      'action': 'get_chat_rooms',
      'searchText': null,
    });
  }

  void joinRoom() {
    _emit({
      'action': 'join_room',
      'roomId': _selectedRoom!['room_id'],
      'agentCode': _selectedRoom!['agent_code'],
    });
  }

  void resetRoomUnreadCount() {
    developer.log('reset room count called');
    _emit({
      'action': 'reset_room_unread_count',
      'roomId': _selectedRoom!['room_id'],
    });
  }

  void sendMessage(String text, List<String> attachmentPaths) {
    _emit({
      'action': 'new_message',
      'text': text,
      'attachmentPaths': attachmentPaths,
      'roomId': _selectedRoom!['room_id'],
    });
  }

  void _onDisconnected() {
    developer.log('disconneced on _onDisconnected');
    _isConnected = false;
    notifyListeners();
    _socket?.sink.close();
    _socket = null;
    notifyListeners();
    _attemptReconnect();
  }

  void disconnect() {
    _socket?.sink.close();
    _socket = null;
    _isConnected = false;

    _reconnectTimer?.cancel();
    notifyListeners();
  }

  void _attemptReconnect() {
    // Cancel any existing reconnect timer
    _reconnectTimer?.cancel();

    // Set up a new reconnect timer
    _reconnectTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!_isConnected) {
        developer.log('Attempting to reconnect...');
        try {
          final response = await Request().requestWithRefreshToken(url: 'agent/userInfo', method: 'GET');
          Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
          if (response.statusCode != 200) throw decodedRes['message'] ?? "Fetch userInfo error";
        } catch (e) {
          developer.log(e.toString());
        }

        connect();
      } else {
        timer.cancel();
      }
    });
  }
}
