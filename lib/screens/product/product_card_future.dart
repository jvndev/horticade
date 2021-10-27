import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/create/finalize_order.dart';
import 'package:firebase/screens/product/product_card.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class ProductCardFuture extends StatefulWidget {
  final Future<Product> product;
  final AuthUser authUser;

  const ProductCardFuture(
      {Key? key, required this.product, required this.authUser})
      : super(key: key);

  @override
  _ProductCardStateFuture createState() => _ProductCardStateFuture();
}

class _ProductCardStateFuture extends State<ProductCardFuture> {
  Product? product;

  @override
  void initState() {
    super.initState();

    widget.product.then((p) {
      setState(() {
        product = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          )
        : GestureDetector(
            onTap: () {
              if (product!.ownerUid != widget.authUser.uid) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FinalizeOrder(
                          product: product!,
                          authUser: widget.authUser,
                        )));
              }
            },
            child: ProductCard(product: product as Product),
          );
  }
}
