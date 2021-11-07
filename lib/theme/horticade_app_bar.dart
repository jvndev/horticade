import 'package:flutter/material.dart';
import 'package:horticade/theme/horticade_theme.dart';

class HorticadeAppBar extends AppBar {
  HorticadeAppBar({
    Key? key,
    required String title,
    List<Widget>? actions,
  }) : super(
          key: key,
          centerTitle: true,
          title: Text(title),
          backgroundColor: HorticadeTheme.appbarBackground,
          iconTheme: HorticadeTheme.appbarIconsTheme,
          actionsIconTheme: HorticadeTheme.appbarIconsTheme,
          titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
          actions: actions,
        );
}
