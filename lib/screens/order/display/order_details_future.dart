import 'package:firebase/models/order.dart';
import 'package:firebase/screens/order/display/order_details.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class OrderDetailsFuture extends StatefulWidget {
  final Future<Order> order;

  const OrderDetailsFuture({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsFuture> createState() => _OrderDetailsFutureState();
}

class _OrderDetailsFutureState extends State<OrderDetailsFuture> {
  Order? order;

  @override
  void initState() {
    super.initState();

    widget.order.then((o) {
      setState(() {
        order = o;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return order == null
        ? Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          )
        : OrderDetails(order: order!);
  }
}
