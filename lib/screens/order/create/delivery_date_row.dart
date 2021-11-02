///
/// Used in finalize_order.dart
///
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:horticade/shared/constants.dart';

class DeliveryDateRow extends StatelessWidget {
  final VoidFunc set;
  final VoidFunc unset;
  final DateTime? deliveryDate;

  const DeliveryDateRow({
    Key? key,
    required this.deliveryDate,
    required this.set,
    required this.unset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoidFunc onPressed;
    String buttonText;
    String outputText;

    if (deliveryDate == null) {
      onPressed = set;
      buttonText = 'Set';
      outputText = 'Delivery Date';
    } else {
      onPressed = unset;
      buttonText = 'Unset';
      outputText = 'Req. delivery date: ${d(deliveryDate!)}';
    }

    return Row(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: HorticadeTheme.actionButtonTextStyle,
          ),
          style: HorticadeTheme.actionButtonTheme,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(outputText),
      ],
    );
  }
}
