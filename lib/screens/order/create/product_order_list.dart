import 'package:firebase/models/category.dart';
import 'package:firebase/models/order.dart';
import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/create/filter.dart';
import 'package:firebase/screens/order/create/finalize_order.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase/screens/product/product_card.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/loader.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

class ProductOrderList extends StatefulWidget {
  final AuthUser authUser;
  final Filter filter;

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
  final TextEditingController productNameController = TextEditingController();
  final GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();
  List<DropdownMenuItem<Category>>? _categoryItems;
  String fromPrice = '', toPrice = '';

  Future<Order?> _confirmOrder(Product product) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FinalizeOrder(
            product: product,
            authUser: widget.authUser,
          ),
        ),
      );

  String? priceValidator(String? val) {
    if (val == null || val.isEmpty) {
      // there doesn't have to be a price filter
      return null;
    }
    if (!RegExp(r'^\d+$').hasMatch(val) || int.parse(val) <= 0) {
      return 'Invalid price';
    }
    if (fromPrice.isNotEmpty &&
        RegExp(r'^\d+$').hasMatch(fromPrice) &&
        toPrice.isNotEmpty &&
        RegExp(r'^\d+$').hasMatch(toPrice)) {
      if (int.parse(fromPrice) > int.parse(toPrice)) {
        return 'From price is greater than To price';
      }
    }
  }

  void fromPriceFilterChanged(String val, Filter filter) {
    fromPrice = val;

    if (priceFormKey.currentState!.validate()) {
      filter.fromPrice = fromPrice;
    }
  }

  void toPriceFilterChanged(String val, Filter filter) {
    toPrice = val;

    if (priceFormKey.currentState!.validate()) {
      filter.toPrice = toPrice;
    }
  }

  Future<List<String>> lookAheadProductNames(String search) async {
    List<Product> products =
        await Provider.of<Future<List<Product>>>(context, listen: false);
    List<String> productNames =
        products.map((product) => product.name).toList();

    return search.isEmpty
        ? productNames
        : productNames
            .where((name) => name.toLowerCase().contains(search.toLowerCase()))
            .toList();
  }

  @override
  void initState() {
    super.initState();

    databaseService.categories.then((categories) {
      setState(() {
        _categoryItems = categories
            .map((Category category) => DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                ))
            .toList();
      });
    });

    productNameController.addListener(() {
      widget.filter.name = productNameController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      initialData: const [],
      future: Provider.of<Future<List<Product>>>(context),
      builder: (context, snapshot) {
        List<Product>? products =
            snapshot.hasData && snapshot.data != null ? snapshot.data : null;

        return Column(
          children: [
            Expanded(
              flex: 1,
              child: _categoryItems == null
                  ? Loader(
                      color: Colors.orange,
                      background: HorticadeTheme.scaffoldBackground!,
                    )
                  : DropdownButtonFormField<Category>(
                      decoration: const InputDecoration(
                        label: Text('Category'),
                      ),
                      hint: const Text('Filter by Category'),
                      value: null,
                      items: _categoryItems,
                      isExpanded: false,
                      onChanged: (category) =>
                          widget.filter.category = category,
                    ),
            ),
            Expanded(
              flex: 1,
              child: TypeAheadField<String>(
                loadingBuilder: (context) => Loader(
                  color: Colors.orange,
                  background: HorticadeTheme.lookAheadTileColor!,
                ),
                suggestionsCallback: lookAheadProductNames,
                itemBuilder: (context, productName) => ListTile(
                  tileColor: HorticadeTheme.lookAheadTileColor,
                  title: Text(
                    productName,
                    style: HorticadeTheme.lookAheadDropdownTextStyle,
                  ),
                ),
                onSuggestionSelected: (String name) {
                  widget.filter.name = name;
                  productNameController.text = name;
                },
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: textFieldDecoration('Filter by Product Name'),
                  controller: productNameController,
                ),
                noItemsFoundBuilder: (context) => const Text(
                  'No Matching Items',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Form(
                key: priceFormKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: textFieldDecoration('Price From'),
                        onChanged: (val) =>
                            fromPriceFilterChanged(val, widget.filter),
                        validator: priceValidator,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: textFieldDecoration('Price To'),
                        onChanged: (val) =>
                            toPriceFilterChanged(val, widget.filter),
                        validator: priceValidator,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            formTextSpacer,
            Expanded(
              flex: 9,
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
                          key: Key('product_order_list${products.length}'),
                          itemCount: products.length,
                          itemBuilder: (context, i) => ProductCard(
                            product: products[i],
                            onTap: () => _confirmOrder(products[i]),
                          ),
                        )),
            ),
          ],
        );
      },
    );
  }
}
