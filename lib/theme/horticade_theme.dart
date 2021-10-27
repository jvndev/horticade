import 'package:flutter/material.dart';

class HorticadeTheme {
  static const horticateLogo = 'assets/horticade_logo.png';
  static final appbarBackground = Colors.grey[700];
  static const appbarIconsTheme = IconThemeData(
    color: Colors.orange,
  );
  static const appbarTitleTextStyle = TextStyle(
    letterSpacing: 1.5,
    fontWeight: FontWeight.bold,
    fontSize: 19,
  );
  static final scaffoldBackground = Colors.grey[500];
  static final actionButtonTheme = ElevatedButton.styleFrom(
    primary: Colors.grey[700],
  );
  static const actionButtonTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static final cardColor = Colors.green[900];
  static const cardTitleTextStyle = TextStyle(color: Colors.orange);
  static const cardSubTitleTextStyle = TextStyle(color: Colors.orangeAccent);
  static const cardTrailingTextStyle = TextStyle(color: Colors.orange);
  static final checkBoxActive = Colors.grey[700];
  static const datePickerPrimary = Color(0xFF616161);

  static MaterialColor calenderColorSwatch = const MaterialColor(
    0xFF616161,
    <int, Color>{
      50: Color(0xFF616161),
      100: Color(0xFF616161),
      200: Color(0xFF616161),
      300: Color(0xFF616161),
      400: Color(0xFF616161),
      500: Color(0xFF616161),
      600: Color(0xFF616161),
      700: Color(0xFF616161),
      800: Color(0xFF616161),
      900: Color(0xFF616161),
    },
  );
}
