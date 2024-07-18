import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    Color primaryColor = const Color(0xFF006DDA);

    Color backgroundColor = const Color.fromARGB(255, 239, 248, 255);

    InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle: const TextStyle(color: Colors.black26),

      constraints: const BoxConstraints(
        maxHeight: 45,
        minHeight: 44,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        // borderSide: BorderSide.none,
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 1,
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
        vertical: 11,
      ),

      isDense: true,
      // isCollapsed: true,
      labelStyle: const TextStyle(
        color: Colors.black54,
        fontSize: 15,
      ),
    );

    return ThemeData(
      // scaffoldBackgroundColor: Colors.white,
      // drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),

      appBarTheme: const AppBarTheme(
        // titleSpacing: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.black87,
        ),
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        onPrimary: Colors.white,

        secondary: Colors.black87,

        tertiary: Colors.black26,
        onTertiary: Colors.amber,

        onSecondary: Colors.red,

        background: backgroundColor, //whole app background
        surface: backgroundColor, //button and all surfaces

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
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        side: const BorderSide(color: Colors.black26),
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
            minimumSize: const Size(0, 45),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            disabledBackgroundColor: const Color.fromARGB(255, 163, 177, 192)),
      ),

      inputDecorationTheme: inputDecorationTheme,

      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: const MenuStyle(
          padding: MaterialStatePropertyAll(EdgeInsets.zero),
          // visualDensity: VisualDensity.compact,
          surfaceTintColor: MaterialStatePropertyAll(Colors.transparent),
          backgroundColor: MaterialStatePropertyAll(Colors.white),
        ),
        inputDecorationTheme: inputDecorationTheme,
      ),

      menuButtonTheme: MenuButtonThemeData(
        // style: ButtonStyle(
        //   textStyle: MaterialStatePropertyAll(TextStyle(fontSize: ))
        // ),

        style: MenuItemButton.styleFrom(
          textStyle: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),

      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          // iconSize: 20,
          // backgroundColor: Colors.green,
          // iconSize: 10,
          // maximumSize: const Size(25, 25),
          // minimumSize: const Size(20, 20),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
        ),
      ),

      sliderTheme: SliderThemeData(
        // trackHeight: 2.0,
        // minThumbSeparation: 0,
        overlayShape: SliderComponentShape.noOverlay,
      ),
    );
  }
}
