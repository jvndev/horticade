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

  static final dropdownMenuColor = Colors.grey[700];
  static const dropdownMenuIconColor = Colors.orange;
  static const dropdownMenuTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  static final dropdownMenuItemStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.grey[700]),
    elevation: MaterialStateProperty.all(0),
    side: MaterialStateProperty.all(BorderSide.none),
  );
  static const lookAheadDropdownTextStyle = TextStyle(
    color: Colors.orange,
    fontSize: 14,
  );
  static final lookAheadTileColor = Colors.grey[700];
  static final bottomSheetDecoration = BoxDecoration(color: Colors.grey[700]);
  static const bottomSheetIconColor = Colors.orange;
  static const bottomSheetTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );
  static const noData = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  static final confirmationDialogBackground = Colors.grey[700];
  static const confirmationDialogTitleStyle = TextStyle(
    color: Colors.orange,
  );
}
