import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/create/filter.dart';
import 'package:firebase/screens/order/create/product_order_list.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/services/image.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOrder extends StatelessWidget {
  final AuthUser authUser;
  final DatabaseService databaseService = DatabaseService();
  final ImageService imageService = ImageService();

  ProductOrder({
    Key? key,
    required this.authUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Filter filter = Provider.of<Filter>(context);

    return StreamProvider<Future<List<Product>>>.value(
      value: databaseService.productStream(filters: filter.getFilters),
      initialData: Future(() => const <Product>[]),
      builder: (context, widget) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Place Order'),
          backgroundColor: HorticadeTheme.appbarBackground,
          iconTheme: HorticadeTheme.appbarIconsTheme,
          actionsIconTheme: HorticadeTheme.appbarIconsTheme,
          titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
        ),
        backgroundColor: HorticadeTheme.scaffoldBackground,
        body: ProductOrderList(
          authUser: authUser,
          filter: filter,
        ),
      ),
    );
  }
}
