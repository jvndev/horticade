import 'package:horticade/screens/authenticate/login.dart';
import 'package:horticade/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _showLogin = true;

  void _toggleView() {
    setState(() => _showLogin = !_showLogin);
  }

  @override
  Widget build(BuildContext context) {
    return _showLogin
        ? Login(
            toggleView: _toggleView,
          )
        : Register(
            toggleView: _toggleView,
          );
  }
}
