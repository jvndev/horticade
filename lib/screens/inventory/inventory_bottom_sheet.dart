import 'package:flutter/material.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/theme/horticade_theme.dart';

typedef InventoryFunc = void Function(Product);

class InventoryBottomSheet extends StatelessWidget {
  final Product product;
  final InventoryFunc onChange;

  const InventoryBottomSheet({
    Key? key,
    required this.product,
    required this.onChange,
  }) : super(key: key);

  Future<void> _alterQuantity(Product product, int qty) async {
    product.qty = qty;
    onChange(product);
  }

  Future<void> incQuantity(Product product) async {
    _alterQuantity(product, product.qty + 1);
  }

  @override
  Widget build(BuildContext context) {
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

    return Wrap(
      children: [
        BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) => Container(
            decoration: HorticadeTheme.bottomSheetDecoration,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: HorticadeTheme.bottomSheetIconColor,
                        ),
                      ),
                      Text(
                        product.name,
                        style: HorticadeTheme.bottomSheetTextStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        color: HorticadeTheme.bottomSheetIconColor,
                        onPressed: () => updateQuantity(product),
                        icon: const Icon(Icons.inventory_2),
                      ),
                      IconButton(
                        color: HorticadeTheme.bottomSheetIconColor,
                        onPressed: () => incQuantity(product),
                        icon: const Icon(Icons.plus_one),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}