import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/order/filter/order_filter.dart';
import 'package:horticade/screens/order/create/finalize_order.dart';
import 'package:horticade/screens/order/filter/order_filter_bottom_sheet.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:horticade/screens/product/product_card.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:provider/provider.dart';

class ProductOrderList extends StatefulWidget {
  final AuthUser authUser;
  final OrderFilter filter;

  const ProductOrderList({
    Key? key,
    required this.authUser,
    required this.filter,
  }) : super(key: key);

  @override
  State<ProductOrderList> createState() => _ProductOrderListState();
}

class _ProductOrderListState extends State<ProductOrderList> {
  final DatabaseService databaseService = DatabaseService();

  Future<Order?> _confirmOrder(Product product) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FinalizeOrder(
            product: product,
            authUser: widget.authUser,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      initialData: const [],
      future: Provider.of<Future<List<Product>>>(context),
      builder: (context, snapshot) {
        List<Product>? products;
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          products = null;
        } else {
          products = snapshot.data!;
        }

        return Center(
          child: Column(
            children: [
              ElevatedButton(
                style: HorticadeTheme.actionButtonTheme,
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (_) => OrderFilterBottomSheet(
                      filter: widget.filter,
                    ),
                  );
                },
                child: const Text(
                  'Filter',
                  style: HorticadeTheme.actionButtonTextStyle,
                ),
              ),
              Expanded(
                flex: 11,
                child: products == null
                    ? Loader(
                        color: Colors.orange,
                        background: HorticadeTheme.scaffoldBackground!,
                      )
                    : (products.isEmpty
                        ? const Text(
                            'No Products Found',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )
                        : ListView.builder(
                            key: Key('product_order_list_${products.length}'),
                            itemCount: products.length,
                            itemBuilder: (context, i) => ProductCard(
                              product: products![i],
                              onTap: () => _confirmOrder(products![i]),
                            ),
                          )),
              ),
            ],
          ),
        );
      },
    );
  }
}
