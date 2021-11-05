import 'package:flutter/material.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/inventory/inventory.dart';
import 'package:horticade/screens/inventory/product_filter.dart';
import 'package:horticade/services/database.dart';
import 'package:provider/provider.dart';

class InventoryStreamProvider extends StatelessWidget {
  final AuthUser authUser;
  final DatabaseService databaseService = DatabaseService();

  InventoryStreamProvider({
    Key? key,
    required this.authUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProductFilter productFilter = Provider.of<ProductFilter>(context);

    return StreamProvider<Future<List<Product>>>.value(
      value: DatabaseService.productStream(
        filters: productFilter.filters,
      ),
      initialData: Future(() => const []),
      builder: (context, snapshot) {
        return Inventory(
          authUser: authUser,
          productFilter: productFilter,
        );
      },
    );
  }
}
