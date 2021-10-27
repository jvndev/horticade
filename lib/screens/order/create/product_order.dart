import 'package:firebase/models/category.dart';
import 'package:firebase/models/order.dart';
import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/create/finalize_order.dart';
import 'package:firebase/screens/product/product_card.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/services/image.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class ProductOrder extends StatefulWidget {
  final AuthUser authUser;

  const ProductOrder({Key? key, required this.authUser}) : super(key: key);

  @override
  _ProductOrderState createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DatabaseService db = DatabaseService();
  final ImageService images = ImageService();

  List<Category> _categories = [];
  List<Product> _products = [];

  Category? _selectedCategory;
  String _status = '';
  String _searchText = '';
  bool _creating = false;

  @override
  void initState() {
    super.initState();

    db.categories.then((categories) {
      setState(() {
        _categories = categories;
      });
    });
  }

  void _search(String searchText) {
    if (_selectedCategory != null) {
      db
          .findProductsByNameExcludeOwned(
        _selectedCategory as Category,
        searchText,
        widget.authUser.uid,
      )
          .then((products) {
        setState(() {
          _products = products;

          if (products.isEmpty) {
            _status = 'No products found.';
          }
        });
      });
    }
  }

  Future<Order?> _confirmOrder(Product product) async =>
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FinalizeOrder(
          product: product,
          authUser: widget.authUser,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Category>> _categoryItems = _categories
        .map((Category category) => DropdownMenuItem<Category>(
              value: category,
              child: Text(category.name),
            ))
        .toList();
    List<ProductCard> _productItems = _products
        .map<ProductCard>((product) => ProductCard(
              product: product,
              onTap: () => _confirmOrder(product),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: Padding(
        padding: formPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    DropdownButtonFormField<Category>(
                      decoration: const InputDecoration(
                        label: Text('Category'),
                      ),
                      hint: const Text('Select a category'),
                      value: null,
                      items: _categoryItems,
                      isExpanded: false,
                      onChanged: (category) {
                        _selectedCategory = category;

                        setState(() {
                          _status = '';
                        });

                        _search(_searchText);
                      },
                    ),
                    TextFormField(
                      onChanged: (val) {
                        _searchText = val;
                        if (_selectedCategory == null) {
                          setState(() {
                            _status = 'Please select a category';
                          });
                        } else {
                          _search(val);
                        }
                      },
                      decoration: textFieldDecoration('Search products'),
                    ),
                    _creating
                        ? Loader(
                            color: Colors.orange,
                            background: HorticadeTheme.scaffoldBackground!,
                          )
                        : Text(_status),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: ListView.builder(
                  itemCount: _productItems.length,
                  itemBuilder: (context, i) => _productItems[i],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
