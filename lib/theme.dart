import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    Color primaryColor = const Color(0xFF006DDA);

    return ThemeData(
      // scaffoldBackgroundColor: Colors.white,
      // drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
      // appBarTheme: const AppBarTheme(backgroundColor: Colors.white),

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        onPrimary: Colors.white,

        secondary: Colors.black87,

        tertiary: Colors.black26,
        onTertiary: Colors.amber,

        onSecondary: Colors.red,
        background: Colors.white, //whole app background

        surface: Colors.white, //button and all surfaces
        surfaceTint: Colors.transparent,
        onBackground: Colors.amber,

        // onSurface: Colors.red,
        outline: Colors.red,
        outlineVariant: Colors.pink,

        primaryContainer: Colors.red,
      ),
      fontFamily: 'Roboto',
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFF006DDA),
        textTheme: ButtonTextTheme.primary,
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(fontWeight: FontWeight.w600),
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: 400,
      ),
      checkboxTheme: CheckboxThemeData(
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        side: const BorderSide(
          color: Colors.black26,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      radioTheme: RadioThemeData(
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) return primaryColor; // Color when selected
          return Colors.black38;
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          // borderSide: BorderSide.none,
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade500,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade500,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
        isDense: true,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 15,
        ),
        errorStyle: const TextStyle(
          height: 1,
          fontWeight: FontWeight.w600,
          color: Colors.red,
        ),
      ),

      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
