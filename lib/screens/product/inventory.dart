import 'package:firebase/models/category.dart';
import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/product/product_card.dart';
import 'package:firebase/services/database.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Inventory extends StatefulWidget {
  final AuthUser authUser;

  const Inventory({Key? key, required this.authUser}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Product> products = [];
  DatabaseService db = DatabaseService();

  bool busy = false;

  @override
  void initState() {
    super.initState();

    busy = true;
    db.findProductsByOwner(widget.authUser.uid).then((ret) {
      setState(() {
        products = ret;
        busy = false;
      });
    });
  }

  Future<void> _alterQuantity(Product product, int qty) async {
    product.qty = qty;

    await db.createProduct(product);

    setState(() {
      products[products.indexOf(product)].qty = qty;
    });
  }

  Future<void> incQuantity(Product product) async {
    _alterQuantity(product, product.qty + 1);
  }

  Future<void> updateQuantity(Product product) async {
    GlobalKey<FormState> _dialogKey = GlobalKey<FormState>();
    TextEditingController qtyController = TextEditingController();

    int? qty = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Alter ${product.name} Quantity"),
        content: Form(
          key: _dialogKey,
          child: Column(
            children: [
              TextFormField(
                validator: (qty) {
                  if (qty == null || qty.isEmpty) {
                    return 'Qty is required';
                  }

                  if (!RegExp(r'^\d+$').hasMatch(qty)) {
                    return 'Invalid quantity.';
                  }

                  return null;
                },
                decoration: textFieldDecoration('New Quantity'),
                controller: qtyController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () => Navigator.of(context).pop(null),
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            color: Colors.greenAccent,
            onPressed: () {
              if (_dialogKey.currentState!.validate()) {
                Navigator.of(context).pop(int.parse(qtyController.text));
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );

    if (qty != null) {
      await _alterQuantity(product, qty);
    }
  }

  Future<void> deleteProduct(product) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inventory'),
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: Column(
        children: [
          Expanded(
            child: busy
                ? Loader(
                    color: Colors.orange,
                    background: HorticadeTheme.scaffoldBackground!,
                  )
                : GroupedListView<Product, Category>(
                    elements: products,
                    groupBy: (product) => product.category,
                    itemBuilder: (context, product) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Column(
                            children: [
                              ProductCard(product: product),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                decoration: BoxDecoration(
                                  color: Colors.green[800],
                                  border: const Border(
                                    top: BorderSide(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                    left: BorderSide(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                    right: BorderSide(
                                      color: Colors.orange,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    /*
                                    Expanded(
                                      child: IconButton(
                                        color: Colors.orange,
                                        onPressed: () => deleteProduct(product),
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                    */
                                    Expanded(
                                      child: IconButton(
                                        color: Colors.orange,
                                        onPressed: () =>
                                            updateQuantity(product),
                                        icon: const Icon(Icons.inventory_2),
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        color: Colors.orange,
                                        onPressed: () => incQuantity(product),
                                        icon: const Icon(Icons.plus_one),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    groupSeparatorBuilder: (category) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
