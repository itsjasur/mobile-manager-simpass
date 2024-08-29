import 'package:flutter/material.dart';

class SidemenuModel extends ChangeNotifier {
  int _currentSelectedMenuIndex = 0;

  int get isAuthenticated => _currentSelectedMenuIndex;

  void _change(int newIndex) {
    _currentSelectedMenuIndex = newIndex;
  }
}
