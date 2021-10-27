import 'dart:io';

import 'package:firebase/shared/image_display.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class ShowPicture extends StatelessWidget {
  final String path;

  const ShowPicture({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ImageDisplay(image: Image.file(File(path))),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              color: Colors.greenAccent,
              iconSize: 70.00,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.check),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
              color: Colors.grey,
              iconSize: 70.00,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ],
      ),
    );
  }
}
