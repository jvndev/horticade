import 'package:firebase/models/order.dart';
import 'package:firebase/screens/order/display/order_card_future.dart';
import 'package:firebase/screens/order/display/order_details_future.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingOrdersList extends StatelessWidget {
  const PendingOrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Future<Order>> orders = Provider.of<List<Future<Order>>>(context);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            key: Key('orderlist${orders.length}'),
            itemCount: orders.length,
            itemBuilder: (context, i) => OrderCardFuture(
              order: orders[i],
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OrderDetailsFuture(order: orders[i])));
              },
            ),
          ),
        )
      ],
    );
  }
}
