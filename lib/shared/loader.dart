import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  final Color color;
  final Color background;

  const Loader({
    Key? key,
    required this.color,
    required this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitThreeBounce(
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
