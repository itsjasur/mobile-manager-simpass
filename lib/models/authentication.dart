import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationModel extends ChangeNotifier {
  final WebSocketModel _webSocketProvider;
  AuthenticationModel(this._webSocketProvider);

  bool _isAuthenticated = true;
  String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;

  Future<void> login(String accessToken, String refreshToken, String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

    await prefs.setString('username', username);

    _isAuthenticated = true;
    notifyListeners();
  }

  //saving login and password in shared preferences is stupid idea. well what can i do? i was told to do so!
  //logout clears login and password saved in the sharedprefernces
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');

    await prefs.remove('username');
    // await prefs.remove('password');

    _isAuthenticated = false;

    _webSocketProvider.disconnect();

    notifyListeners();
  }

  Future<void> setProviderValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('username');
    notifyListeners();
  }
}
