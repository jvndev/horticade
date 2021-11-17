import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:horticade/models/category.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/spec.dart';
import 'package:horticade/models/sub_category.dart';
import 'package:horticade/screens/category/select/categories_dropdown.dart';
import 'package:horticade/screens/category/select/sub_categories_dropdown.dart';
import 'package:horticade/screens/order/filter/order_filter.dart';
import 'package:horticade/screens/specs/specs.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class OrderFilterBottomSheet extends StatefulWidget {
  final OrderFilter filter;

  const OrderFilterBottomSheet({Key? key, required this.filter})
      : super(key: key);

  @override
  _OrderFilterBottomSheetState createState() => _OrderFilterBottomSheetState();
}

class _OrderFilterBottomSheetState extends State<OrderFilterBottomSheet> {
  final TextEditingController productNameController = TextEditingController();
  final GlobalKey<FormState> priceFormKey = GlobalKey<FormState>();
  CurrencyTextInputFormatter fromTextInputFormatter =
      CurrencyTextInputFormatter(symbol: 'R');
  CurrencyTextInputFormatter toTextInputFormatter =
      CurrencyTextInputFormatter(symbol: 'R');
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  List<Spec> selectedSpecs = [];

  void fromPriceFilterChanged(OrderFilter filter) {
    filter.fromPrice = fromTextInputFormatter.getUnformattedValue().toDouble();
  }

  void toPriceFilterChanged(OrderFilter filter) {
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
    return Wrap(
      children: [
        BottomSheet(
          enableDrag: false,
          onClosing: () {},
          shape: HorticadeTheme.bottomSheetShape,
          builder: (context) => Container(
            decoration: HorticadeTheme.bottomSheetDecoration,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.orange,
                      ),
                    ),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CategoriesDropdown(
                        onSelect: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                          widget.filter.category = category;
                        },
                        loader: Loader(
                          color: Colors.orange,
                          background: Colors.grey[700]!,
                        ),
                      ),
                    ),
                    Expanded(
                      child: selectedCategory != null
                          ? SubCategoriesDropdown(
                              category: selectedCategory!,
                              onSelect: (subCategory) {
                                widget.filter.subCategory = subCategory;
                                setState(() {
                                  selectedSubCategory = subCategory;
                                });
                              },
                              loader: Loader(
                                color: Colors.orange,
                                background: Colors.grey[700]!,
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    selectedSubCategory != null
                        ? Expanded(
                            flex: 4,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[500],
                              ),
                              onPressed: () async {
                                List<Spec>? ret = await showDialog<List<Spec>>(
                                        context: context,
                                        builder: (context) {
                                          return Specs(
                                            subCategory: selectedSubCategory!,
                                            selectedSpecs: selectedSpecs,
                                          );
                                        }) ??
                                    selectedSpecs;
                                setState(() {
                                  selectedSpecs = ret;
                                });
                                widget.filter.specs = selectedSpecs;
                              },
                              icon: const Icon(Icons.link),
                              label: const Text(
                                'Specs',
                                style: HorticadeTheme.actionButtonTextStyle,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                TypeAheadField<String>(
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
                    'No Matching Products',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Form(
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
                          onChanged: (val) =>
                              toPriceFilterChanged(widget.filter),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
