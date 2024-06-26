import 'package:horticade/models/entity.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/category/admin/categories.dart';
import 'package:horticade/screens/entity_details.dart';
import 'package:horticade/screens/inventory/inventory.dart';
import 'package:horticade/screens/menu/menu_item.dart';
import 'package:horticade/screens/order/create/product_order.dart';
import 'package:horticade/screens/order/display/pending_orders.dart';
import 'package:horticade/screens/order/display/sent_orders.dart';
import 'package:horticade/screens/product/product_create.dart';
import 'package:horticade/services/auth.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class Menu extends PopupMenuButton<String> {
  final BuildContext context;
  final AuthUser authUser;
  final Entity entity;

  static List<PopupMenuItem<String>> menuItems(Entity entity) {
    List<Map<String, dynamic>> menuItems = [
      {
        'text': 'Create Product',
        'val': 'createProduct',
        'icon': Icons.create,
        'admin': false,
      },
      {
        'text': 'Inventory',
        'val': 'inventory',
        'icon': Icons.inventory,
        'admin': false,
      },
      {
        'text': 'Place Order',
        'val': 'submitOrder',
        'icon': Icons.local_shipping,
        'admin': false,
      },
      {
        'text': 'Orders Placed',
        'val': 'ordersSent',
        'icon': Icons.arrow_upward_rounded,
        'admin': false,
      },
      {
        'text': 'Orders Received',
        'val': 'ordersReceived',
        'icon': Icons.arrow_downward_rounded,
        'admin': false,
      },
      {
        'text': 'Categories',
        'val': 'categories',
        'icon': Icons.category,
        'admin': true,
      },
      {
        'text': 'Settings',
        'val': 'settings',
        'icon': Icons.settings,
        'admin': false,
      },
      {
        'text': 'Log Out',
        'val': 'logout',
        'icon': Icons.person_off,
        'admin': false,
      },
    ];

    return menuItems
        .where((e) => entity.isAdmin || e['admin'] == false)
        .map((e) =>
            MenuItem<String>(text: e['text'], val: e['val'], icon: e['icon']))
        .toList();
  }

  Menu({
    Key? key,
    required this.context,
    required this.authUser,
    required this.entity,
  }) : super(
          color: HorticadeTheme.dropdownMenuColor,
          key: key,
          itemBuilder: (context) => menuItems(entity),
          onSelected: (val) {
            switch (val) {
              case 'createProduct':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ProductCreate(),
                ));
                break;
              case 'submitOrder':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductOrder(),
                ));
                break;
              case 'ordersSent':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SentOrders(),
                ));
                break;
              case 'ordersReceived':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PendingOrders(),
                ));
                break;
              case 'inventory':
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Inventory(),
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
