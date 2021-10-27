import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/product/product_card_future.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsWatchList extends StatefulWidget {
  const ProductsWatchList({Key? key}) : super(key: key);

  @override
  _ProductsWatchListState createState() => _ProductsWatchListState();
}

class _ProductsWatchListState extends State<ProductsWatchList> {
  @override
  Widget build(BuildContext context) {
    AuthUser authUser = Provider.of<AuthUser>(context);
    List<Future<Product>> products =
        Provider.of<List<Future<Product>>>(context);
    List<ProductCardFuture> productItems = products
        .map((product) => ProductCardFuture(
              product: product,
              authUser: authUser,
            ))
        .toList();

    return Expanded(
      child: ListView.builder(
        key: Key('listview${products.length}'),
        itemCount: products.length,
        itemBuilder: (context, i) => productItems[i],
      ),
    );
  }
}
