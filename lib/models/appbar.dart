import 'package:flutter/material.dart';

class AppbarModel extends ChangeNotifier {
  String _title = 'Home';

  String get title => _title;

  void change(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }
}
