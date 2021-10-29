import 'package:firebase/models/product.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/order/create/finalize_order.dart';
import 'package:firebase/screens/product/product_card.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsWatchList extends StatelessWidget {
  final AuthUser authUser;

  const ProductsWatchList({Key? key, required this.authUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      initialData: const <Product>[],
      future: Provider.of<Future<List<Product>>>(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data!;

          return Expanded(
            child: ListView.builder(
              key: Key('listview${products.length}'),
              itemCount: products.length,
              itemBuilder: (context, i) => ProductCard(
                product: products[i],
                onTap: () {
                  if (products[i].ownerUid != authUser.uid) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FinalizeOrder(
                        product: products[i],
                        authUser: authUser,
                      ),
                    ));
                  } else {}
                },
              ),
            ),
          );
        } else {
          return Loader(
            color: Colors.orange,
            background: HorticadeTheme.scaffoldBackground!,
          );
        }
      },
    );
  }
}
