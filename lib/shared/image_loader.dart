import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ImageLoader extends StatelessWidget {
  final Color color;
  final Color background;
  const ImageLoader({Key? key, required this.color, required this.background})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      color: background,
      child: SpinKitThreeBounce(
        color: color,
      ),
    );
  }
}
