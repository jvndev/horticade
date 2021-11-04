import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:horticade/models/order.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/category/categories_dropdown.dart';
import 'package:horticade/screens/order/create/filter.dart';
import 'package:horticade/screens/order/create/finalize_order.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:horticade/screens/product/product_card.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
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
  CurrencyTextInputFormatter fromTextInputFormatter =
      CurrencyTextInputFormatter(symbol: 'R');
  CurrencyTextInputFormatter toTextInputFormatter =
      CurrencyTextInputFormatter(symbol: 'R');

  Future<Order?> _confirmOrder(Product product) async =>
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FinalizeOrder(
            product: product,
            authUser: widget.authUser,
          ),
        ),
      );

  void fromPriceFilterChanged(Filter filter) {
    filter.fromPrice = fromTextInputFormatter.getUnformattedValue().toDouble();
  }

  void toPriceFilterChanged(Filter filter) {
    filter.toPrice = toTextInputFormatter.getUnformattedValue().toDouble();
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
        List<Product>? products;
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          products = null;
        } else {
          products = snapshot.data!;
        }

        return Column(
          children: [
            Expanded(
              flex: 1,
              child: CategoriesDropdown(
                  onSelect: (category) => widget.filter.category = category),
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
                        inputFormatters: <TextInputFormatter>[
                          fromTextInputFormatter,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: textFieldDecoration('Price From'),
                        onChanged: (val) =>
                            fromPriceFilterChanged(widget.filter),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          toTextInputFormatter,
                        ],
                        keyboardType: TextInputType.number,
                        decoration: textFieldDecoration('Price To'),
                        onChanged: (val) => toPriceFilterChanged(widget.filter),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            formTextSpacer,
            Expanded(
              flex: 6,
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
        );
      },
    );
  }
}
