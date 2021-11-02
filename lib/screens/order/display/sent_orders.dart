import 'package:horticade/models/order.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/order/display/order_card.dart';
import 'package:horticade/screens/order/display/order_details.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class SentOrders extends StatefulWidget {
  List<Order> orders = [];
  final AuthUser authUser;

  SentOrders({Key? key, required this.authUser}) : super(key: key);

  @override
  _SentOrders createState() => _SentOrders();
}

class _SentOrders extends State<SentOrders> {
  final DatabaseService databaseService = DatabaseService();
  bool busy = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      busy = true;
    });

    databaseService.sentOrders(widget.authUser.uid).then((orders) {
      setState(() {
        widget.orders = orders;
        busy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders Placed'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: busy
          ? Loader(
              color: Colors.orange,
              background: HorticadeTheme.scaffoldBackground!,
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.orders.length,
                    itemBuilder: (context, i) => OrderCard(
                      order: widget.orders[i],
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              OrderDetails(order: widget.orders[i]),
                        ));
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
