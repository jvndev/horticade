///
/// Used in finalize_order.dart
///
import 'package:horticade/screens/location/location_search.dart';
import 'package:flutter/material.dart';

class DeliveryAddressDialog extends AlertDialog {
  final BuildContext context;
  final Function onLocationSelected;

  DeliveryAddressDialog({
    Key? key,
    required this.context,
    required this.onLocationSelected,
  }) : super(
          key: key,
          title: const Text('Delivery Address'),
          content: Column(
            children: [
              LocationSearch(onSelected: onLocationSelected),
            ],
          ),
          actions: [
            IconButton(
              color: Colors.greenAccent,
              iconSize: 70.00,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(Icons.check),
            ),
            IconButton(
              color: Colors.black,
              iconSize: 70.00,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              icon: const Icon(Icons.clear),
            ),
          ],
        );
}
