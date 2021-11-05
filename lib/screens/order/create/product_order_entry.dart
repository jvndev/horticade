import 'package:horticade/models/user.dart';
import 'package:horticade/screens/order/create/order_filter.dart';
import 'package:horticade/screens/order/create/product_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOrderEntry extends StatelessWidget {
  const ProductOrderEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthUser>(context);

    return ChangeNotifierProvider<OrderFilter>(
      create: (context) => OrderFilter(authUser: authUser),
      builder: (context, widget) => Consumer(
        builder: (context, widget, child) {
          return ProductOrder(
            authUser: authUser,
          );
        },
      ),
    );
  }
}
