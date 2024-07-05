import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          secondary: Colors.blue,
          tertiary: Colors.red,
        ),
        fontFamily: 'Roboto',
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.amber));
  }
}
