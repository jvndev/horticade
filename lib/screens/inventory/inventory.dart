import 'package:flutter/material.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/inventory/inventory_list.dart';
import 'package:horticade/screens/inventory/product_filter.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class Inventory extends StatelessWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthUser>(context);

    return Scaffold(
      appBar: HorticadeAppBar(
        title: 'Inventory',
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: ChangeNotifierProvider<ProductFilter>(
        create: (context) => ProductFilter(authUser: authUser),
        builder: (context, widget) => Consumer<ProductFilter>(
          builder: (context, filter, widget) =>
              StreamProvider<Future<List<Product>>>.value(
            value: DatabaseService.productStream(filters: filter.filters),
            initialData: Future(() => const []),
            builder: (context, widget) => InventoryList(
              filter: filter,
            ),
          ),
        ),
      ),
    );
  }
}
