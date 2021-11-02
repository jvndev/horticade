import 'package:flutter/material.dart';
import 'package:horticade/models/product.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/inventory/inventory.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:provider/provider.dart';

class InventoryEntry extends StatelessWidget {
  const InventoryEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthUser authUser = Provider.of<AuthUser>(context);
    final DatabaseService databaseService = DatabaseService();

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
      body: StreamProvider<Future<List<Product>>>.value(
          value: databaseService.productStream(filters: [
            (Product product) => product.ownerUid == authUser.uid,
          ]),
          initialData: Future(() => const []),
          builder: (context, snapshot) {
            return Inventory(
              authUser: authUser,
            );
          }),
    );
  }
}
