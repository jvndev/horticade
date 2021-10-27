import 'package:firebase/models/order.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/display/pending_orders_list.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingOrders extends StatelessWidget {
  final AuthUser authUser;
  final DatabaseService db = DatabaseService();

  PendingOrders({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Future<Order>>>.value(
      initialData: const [],
      value: db.pendingOrderStream(authUser),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Pending Orders'),
          backgroundColor: HorticadeTheme.appbarBackground,
          iconTheme: HorticadeTheme.appbarIconsTheme,
          actionsIconTheme: HorticadeTheme.appbarIconsTheme,
          titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
        ),
        backgroundColor: HorticadeTheme.scaffoldBackground,
        body: const PendingOrdersList(),
      ),
    );
  }
}
