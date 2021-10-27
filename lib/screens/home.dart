import 'package:firebase/models/entity.dart';
import 'package:firebase/models/user.dart';
import 'package:firebase/screens/categories.dart';
import 'package:firebase/screens/entity_details.dart';
import 'package:firebase/screens/order/display/pending_orders.dart';
import 'package:firebase/screens/order/create/product_order.dart';
import 'package:firebase/screens/order/display/sent_orders.dart';
import 'package:firebase/screens/product/product_create.dart';
import 'package:firebase/screens/product/inventory.dart';
import 'package:firebase/screens/product/products_watch.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/services/image.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final Entity entity;

  const Home({Key? key, required this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthUser? _authUser = Provider.of<AuthUser>(context);

    return Scaffold(
      backgroundColor: HorticadeTheme.scaffoldBackground,
      appBar: AppBar(
        title: Image.asset(
          HorticadeTheme.horticateLogo,
          width: 50,
          height: 50,
        ),
        backgroundColor: HorticadeTheme.appbarBackground,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SentOrders(
                  authUser: _authUser,
                ),
              ));
            },
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PendingOrders(authUser: _authUser),
              ));
            },
            icon: const Icon(Icons.stars),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Inventory(authUser: _authUser),
              ));
            },
            icon: const Icon(Icons.inventory),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Categories(),
              ));
            },
            icon: const Icon(Icons.category),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EntityDetails(entity: entity),
              ));
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              AuthService.logout();
            },
            icon: const Icon(Icons.person_off),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Horticade",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 0, 2.5, 0),
                  child: ElevatedButton(
                    style: HorticadeTheme.actionButtonTheme,
                    child: const Text(
                      'Create Product',
                      style: HorticadeTheme.actionButtonTextStyle,
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductCreate(
                          authUser: _authUser,
                        ),
                      ));
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2.5, 0, 5, 0),
                    child: ElevatedButton(
                      style: HorticadeTheme.actionButtonTheme,
                      child: const Text(
                        'Submit Order',
                        style: HorticadeTheme.actionButtonTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductOrder(
                            authUser: _authUser,
                          ),
                        ));
                      },
                    ),
                  )),
            ],
          ),
          formButtonSpacer,
          const Text(
            'Recently added products',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          formButtonSpacer,
          ProductsWatch(authUser: _authUser),
        ],
      ),
    );
  }
}
