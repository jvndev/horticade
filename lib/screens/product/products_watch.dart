import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/product/products_watch_list.dart';
import 'package:horticade/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsWatch extends StatelessWidget {
  final DatabaseService databaseService = DatabaseService();
  final AuthUser authUser;

  ProductsWatch({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Future<List<Product>>>(
      initialData: Future(() => const <Product>[]),
      create: (context) => DatabaseService.productStream(),
      builder: (context, widget) => ProductsWatchList(authUser: authUser),
    );
  }
}
