import 'package:flutter/material.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/screens/order/display/order_card.dart';
import 'package:horticade/screens/order/display/order_details.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class SentOrdersList extends StatelessWidget {
  const SentOrdersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      initialData: const [],
      future: Provider.of<Future<List<Order>>>(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          );
        } else {
          List<Order> orders = snapshot.data!;

          return Column(
            children: [
              formTextSpacer,
              orders.isEmpty
                  ? const Center(
                      child: Text(
                        'No Orders Placed',
                        style: HorticadeTheme.noData,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        key: Key('sent_orders_list_${orders.length}'),
                        itemCount: orders.length,
                        itemBuilder: (context, i) => OrderCard(
                          order: orders[i],
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetails(order: orders[i]),
                            ));
                          },
                        ),
                      ),
                    ),
            ],
          );
        }
      },
    );
  }
}
