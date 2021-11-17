import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/order/filter/order_filter.dart';
import 'package:horticade/screens/order/create/product_order_list.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/services/image.dart';
import 'package:horticade/theme/horticade_app_bar.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOrder extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();
  final ImageService imageService = ImageService();

  ProductOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthUser>(context);

    return ChangeNotifierProvider<OrderFilter>(
      create: (context) => OrderFilter(authUser: authUser),
      builder: (context, widget) => Consumer(
        builder: (context, widget, child) {
          OrderFilter filter = Provider.of<OrderFilter>(context);

          return StreamProvider<Future<List<Product>>>.value(
            value: DatabaseService.productStream(filters: filter.filters),
            initialData: Future(() => const <Product>[]),
            builder: (context, widget) => Scaffold(
              appBar: HorticadeAppBar(title: 'Place Order'),
              backgroundColor: HorticadeTheme.scaffoldBackground,
              body: ProductOrderList(
                authUser: authUser,
                filter: filter,
              ),
            ),
          );
        },
      ),
    );
  }
}
