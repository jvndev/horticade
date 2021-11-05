import 'package:flutter/material.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/screens/inventory/inventory_bottom_sheet.dart';
import 'package:horticade/screens/inventory/inventory_bottom_sheet_loader.dart';
import 'package:horticade/screens/inventory/product_filter.dart';
import 'package:horticade/screens/product/product_card.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class InventoryList extends StatefulWidget {
  final ProductFilter filter;

  const InventoryList({
    Key? key,
    required this.filter,
  }) : super(key: key);

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      widget.filter.name = nameController.text;
    });
  }

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
                child: TextField(
                  controller: nameController,
                  decoration: textFieldDecoration('Filter by Product Name'),
                ),
              ),
              Expanded(
                flex: 10,
                child: ListView.builder(
                  key: Key('inventory_list_${products.length}'),
                  itemCount: products.length,
                  itemBuilder: (context, i) => ProductCard(
                    product: products[i],
                    onTap: () {
                      showBottomSheet(
                        context: context,
                        builder: (context) => InventoryBottomSheet(
                          product: products[i],
                          onChange: (Product product) async {
                            await databaseService.createProduct(product);
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
