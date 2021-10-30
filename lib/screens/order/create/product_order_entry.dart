import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/create/filter.dart';
import 'package:firebase/screens/order/create/product_order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOrderEntry extends StatelessWidget {
  final AuthUser authUser;

  const ProductOrderEntry({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Filter>(
      create: (context) => Filter(authUser: authUser),
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
