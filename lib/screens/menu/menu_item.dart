import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class MenuItem<T> extends PopupMenuItem<T> {
  final dynamic text;
  final T val;
  final IconData icon;

  MenuItem({
    Key? key,
    required this.text,
    required this.val,
    required this.icon,
  }) : super(
          key: key,
          value: val,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  icon,
                  color: HorticadeTheme.dropdownMenuIconColor,
                ),
              ),
              Text(
                text,
                style: HorticadeTheme.dropdownMenuTextStyle,
              ),
            ],
          ),
        );
}
