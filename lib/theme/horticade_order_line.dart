import 'package:flutter/material.dart';

class HorticadeOrderLine extends StatelessWidget {
  final String heading;
  final String details;

  const HorticadeOrderLine(
      {Key? key, required this.heading, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              heading,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Text(details),
          ),
        ],
      ),
    );
  }
}
