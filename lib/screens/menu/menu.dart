import 'package:horticade/models/entity.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/categories.dart';
import 'package:horticade/screens/entity_details.dart';
import 'package:horticade/screens/menu/menu_item.dart';
import 'package:horticade/screens/order/create/product_order_entry.dart';
import 'package:horticade/screens/order/display/pending_orders.dart';
import 'package:horticade/screens/order/display/sent_orders.dart';
import 'package:horticade/screens/product/inventory.dart';
import 'package:horticade/screens/product/product_create.dart';
import 'package:horticade/services/auth.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class Menu extends PopupMenuButton {
  final BuildContext context;
  final AuthUser authUser;
  final Entity entity;

  Menu({
    Key? key,
    required this.context,
    required this.authUser,
    required this.entity,
  }) : super(
          color: HorticadeTheme.dropdownMenuColor,
          key: key,
          itemBuilder: (context) => [
            MenuItem(
              text: 'Create Product',
              val: 'createProduct',
              icon: Icons.create,
            ),
            MenuItem(
              text: 'Inventory',
              val: 'inventory',
              icon: Icons.inventory,
            ),
            MenuItem(
              text: 'Place Order',
              val: 'submitOrder',
              icon: Icons.local_shipping,
            ),
            MenuItem(
              text: 'Orders Placed',
              val: 'ordersSent',
              icon: Icons.arrow_upward_rounded,
            ),
            MenuItem(
              text: 'Orders Received',
              val: 'ordersReceived',
              icon: Icons.arrow_downward_rounded,
            ),
            MenuItem(
              text: 'Categories',
              val: 'categories',
              icon: Icons.category,
            ),
            MenuItem(
              text: 'Settings',
              val: 'settings',
              icon: Icons.settings,
            ),
            MenuItem(
              text: 'Log Out',
              val: 'logout',
              icon: Icons.person_off,
            ),
          ],
          onSelected: (val) {
            switch (val) {
              case 'createProduct':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductCreate(
                    authUser: authUser,
                  ),
                ));
                break;
              case 'submitOrder':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductOrderEntry(
                    authUser: authUser,
                  ),
                ));
                break;
              case 'ordersSent':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SentOrders(authUser: authUser),
                ));
                break;
              case 'ordersReceived':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PendingOrders(authUser: authUser),
                ));
                break;
              case 'inventory':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Inventory(authUser: authUser),
                ));
                break;
              case 'categories':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Categories(),
                ));
                break;
              case 'settings':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EntityDetails(entity: entity),
                ));
                break;
              case 'logout':
                AuthService.logout();
                break;
            }
          },
        );
}
