import 'package:horticade/models/order.dart';
import 'package:horticade/screens/order/display/order_card.dart';
import 'package:horticade/screens/order/display/order_details.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingOrdersList extends StatelessWidget {
  const PendingOrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Orders Received'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: FutureBuilder<List<Order>>(
          initialData: const <Order>[],
          future: Provider.of<Future<List<Order>>>(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Order> orders = snapshot.data!;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      key: Key('orderlist${orders.length}'),
                      itemCount: orders.length,
                      itemBuilder: (context, i) => OrderCard(
                        order: orders[i],
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                OrderDetails(order: orders[i]),
                          ));
                        },
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Loader(
                color: Colors.orange,
                background: HorticadeTheme.scaffoldBackground!,
              );
            }
          }),
    );
  }
}
