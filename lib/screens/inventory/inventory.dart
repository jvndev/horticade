import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/inventory/inventory_list.dart';
import 'package:flutter/material.dart';
import 'package:horticade/screens/inventory/product_filter.dart';
import 'package:provider/provider.dart';

class Inventory extends StatelessWidget {
  final AuthUser authUser;
  final ProductFilter productFilter;

  const Inventory({
    Key? key,
    required this.authUser,
    required this.productFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Product>>.value(
      value: Provider.of<Future<List<Product>>>(context),
      initialData: const [],
      builder: (context, widget) => InventoryList(
        productFilter: productFilter,
      ),
    );
  }
}
