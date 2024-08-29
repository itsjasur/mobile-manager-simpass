import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationModel extends ChangeNotifier {
  bool _isAuthenticated = true;
  // String? _userName;

  bool get isAuthenticated => _isAuthenticated;
  // String? get userName => _userName;

  Future<void> login(String accessToken, String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', accessToken);
    await prefs.setString('refreshToken', refreshToken);

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
    await prefs.remove('password');

    _isAuthenticated = false;
    notifyListeners();
  }
}
