import 'package:flutter/material.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/screens/inventory/inventory_bottom_sheet.dart';
import 'package:horticade/screens/inventory/inventory_filter.dart';
import 'package:horticade/screens/inventory/product_filter.dart';
import 'package:horticade/screens/product/product_card.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class InventoryList extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();
  final ProductFilter productFilter;
  Product? selectedProduct;

  InventoryList({Key? key, required this.productFilter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: Provider.of<Future<List<Product>>>(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data!;

          return Column(
            children: [
              Expanded(
                flex: 2,
                child: InventoryFilter(
                  products: products,
                  onSelected: (product) {
                    selectedProduct = product;
                    productFilter.name = product.name;
                  },
                  onChanged: (search) {
                    productFilter.name = search;
                  },
                ),
              ),
              Expanded(
                flex: 10,
                child: ListView.builder(
                  itemCount: products.length,
                  key: Key('grouped_list_view_${products.length}'),
                  itemBuilder: (context, i) => ProductCard(
                    product: products[i],
                    onTap: () {
                      showBottomSheet(
                        context: context,
                        builder: (context) => InventoryBottomSheet(
                          product: products[i],
                          onChange: (Product product) async {
                            await databaseService.createProduct(products[i]);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          );
        }
      },
    );
  }
}
