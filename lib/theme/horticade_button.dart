import 'package:flutter/material.dart';

class HorticadeButton extends StatelessWidget {
  final dynamic onPressed;
  final String label;

  const HorticadeButton(
      {Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            backgroundBlendMode: BlendMode.colorBurn,
            boxShadow: [
              BoxShadow(
                offset: Offset.fromDirection(90, 2.0),
                blurRadius: 45.0,
              ),
            ],
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(180.0)),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('assets/button1.jpg').image,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
