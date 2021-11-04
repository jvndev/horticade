import 'package:horticade/models/order.dart';
import 'package:horticade/screens/order/display/order_card.dart';
import 'package:horticade/screens/order/display/order_details.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingOrdersList extends StatelessWidget {
  const PendingOrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
        initialData: const <Order>[],
        future: Provider.of<Future<List<Order>>>(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
            return Loader(
              color: Colors.orange,
              background: HorticadeTheme.scaffoldBackground!,
            );
          }
          {
            List<Order> orders = snapshot.data!;

            return Column(
              children: [
                formTextSpacer,
                orders.isEmpty
                    ? const Center(
                        child: Text(
                          'No Orders Received',
                          style: HorticadeTheme.noData,
                        ),
                      )
                    : ListView.builder(
                        key: Key('pending_orders_list_${orders.length}'),
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
              ],
            );
          }
        });
  }
}
