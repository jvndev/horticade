import 'package:firebase/models/order.dart';
import 'package:firebase/screens/order/display/order_card.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class OrderCardFuture extends StatefulWidget {
  final Future<Order> order;
  final dynamic onPressed;

  const OrderCardFuture({Key? key, required this.order, this.onPressed})
      : super(key: key);

  @override
  _OrderCardFutureState createState() => _OrderCardFutureState();
}

class _OrderCardFutureState extends State<OrderCardFuture> {
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
        : OrderCard(
            order: order!,
            onPressed: widget.onPressed,
          );
  }
}
