import 'package:horticade/models/entity.dart';
import 'package:horticade/models/user.dart';
import 'package:horticade/screens/menu/menu.dart';
import 'package:horticade/screens/product/products_watch.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/constants.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final AuthUser authUser;

  const Home({Key? key, required this.authUser}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Entity? entity;
  final DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();

    databaseService.findEntity(widget.authUser.uid).then((entity) {
      setState(() {
        this.entity = entity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthUser? _authUser = Provider.of<AuthUser>(context);

    return Scaffold(
      backgroundColor: HorticadeTheme.scaffoldBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset(
                HorticadeTheme.horticateLogo,
                width: 50,
                height: 50,
              ),
            ),
            const Text("Horticade",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                )),
          ],
        ),
        backgroundColor: HorticadeTheme.appbarBackground,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        actions: [
          entity == null
              ? Loader(
                  color: Colors.orange,
                  background: HorticadeTheme.appbarBackground!,
                )
              : Menu(
                  context: context,
                  authUser: _authUser,
                  entity: entity!,
                )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          formTextSpacer,
          const Text(
            'Recently added products',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          formButtonSpacer,
          ProductsWatch(authUser: _authUser),
        ],
      ),
    );
  }
}
