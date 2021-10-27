import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/product/products_watch_list.dart';
import 'package:firebase/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsWatch extends StatelessWidget {
  final DatabaseService db = DatabaseService();
  final AuthUser authUser;

  ProductsWatch({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Future<Product>>>.value(
      initialData: const [],
      value: db.productStream,
      child: const ProductsWatchList(),
    );
  }
}
