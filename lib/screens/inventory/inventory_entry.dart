import 'package:flutter/material.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/inventory/inventory_stream_provider.dart';
import 'package:horticade/screens/inventory/product_filter.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class InventoryEntry extends StatelessWidget {
  const InventoryEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthUser>(context);

    return ChangeNotifierProvider<ProductFilter>(
      create: (context) => ProductFilter(authUser: authUser),
      builder: (context, widget) => Consumer(
        builder: (context, filter, widget) => Scaffold(
          appBar: HorticadeAppBar(title: 'Inventory'),
          backgroundColor: HorticadeTheme.scaffoldBackground,
          body: InventoryStreamProvider(authUser: authUser),
        ),
      ),
    );
  }
}
