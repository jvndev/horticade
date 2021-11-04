import 'package:horticade/models/order.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/order/display/sent_orders_list.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SentOrders extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();

  SentOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthUser>(context);

    return StreamProvider<Future<List<Order>>>.value(
      initialData: Future(() => const []),
      value: databaseService.orderStream(
        filters: <OrderPredicate>[
          (order) => order.clientUid == authUser.uid,
        ],
      ),
      builder: (context, widget) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Orders Placed'),
          backgroundColor: HorticadeTheme.appbarBackground,
          iconTheme: HorticadeTheme.appbarIconsTheme,
          actionsIconTheme: HorticadeTheme.appbarIconsTheme,
          titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
        ),
        backgroundColor: HorticadeTheme.scaffoldBackground,
        body: const SentOrdersList(),
      ),
    );
  }
}
