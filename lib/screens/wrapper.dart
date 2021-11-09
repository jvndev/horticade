import 'package:horticade/models/user.dart';
import 'package:horticade/screens/authenticate/authenticate.dart';
import 'package:horticade/screens/home.dart';
import 'package:horticade/services/database.dart';
import 'package:horticade/shared/loader.dart';
import 'package:horticade/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final DatabaseService databaseService = DatabaseService();
  Widget home = Loader(
    color: Colors.orange,
    background: HorticadeTheme.scaffoldBackground!,
  );

  @override
  Widget build(BuildContext context) {
    AuthUser? authUser = Provider.of<AuthUser?>(context);

    if (authUser == null) {
      return const Authenticate();
    } else {
      return Home(authUser: authUser);
    }
  }
}
