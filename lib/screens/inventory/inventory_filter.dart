import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/types.dart';
import 'package:horticade/theme/horticade_theme.dart';

typedef TypeAheadChangedFunc = void Function(List<Product>);

class InventoryFilter extends StatelessWidget {
  final List<Product> products;
  final VoidProductFunc onSelected;
  final TypeAheadChangedFunc onChanged;
  final TextEditingController nameFilterController = TextEditingController();

  InventoryFilter({
    Key? key,
    required this.products,
    required this.onSelected,
    required this.onChanged,
  }) : super(key: key);

  List<Product> filter(List<Product> products, String search) {
    List<Product> _products = products
        .where((product) =>
            product.name.toLowerCase().contains(search.toLowerCase()))
        .toList();

    onChanged(_products);

    return _products;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Product>(
      suggestionsCallback: (search) => filter(products, search),
      onSuggestionSelected: (product) {
        onSelected(product);
        nameFilterController.text = product.name;
      },
      itemBuilder: (context, product) => ListTile(
        tileColor: HorticadeTheme.lookAheadTileColor,
        title: Text(
          product.name,
          style: HorticadeTheme.lookAheadDropdownTextStyle,
        ),
      ),
      textFieldConfiguration: TextFieldConfiguration(
        decoration: textFieldDecoration('Filter by Product Name'),
        controller: nameFilterController,
      ),
      noItemsFoundBuilder: (context) => const Text(
        'No Matching Products',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
