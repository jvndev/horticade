import 'package:firebase/models/order.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/display/pending_orders_list.dart';
import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingOrders extends StatelessWidget {
  final AuthUser authUser;
  final DatabaseService db = DatabaseService();

  PendingOrders({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<List<Order>>>.value(
      initialData: Future(() => const <Order>[]),
      value: db.pendingOrderStream(
        filter: (order) => order.fulfillerUid == authUser.uid,
      ),
      child: const PendingOrdersList(),
    );
  }
}
