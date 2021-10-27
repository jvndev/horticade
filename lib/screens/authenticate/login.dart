import 'package:firebase/services/auth.dart';
import 'package:firebase/shared/constants.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  const Login({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _loginError = '';
  bool _loading = false;

  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
        actions: [
          IconButton(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person_add),
          ),
        ],
        backgroundColor: HorticadeTheme.appbarBackground,
        iconTheme: HorticadeTheme.appbarIconsTheme,
        actionsIconTheme: HorticadeTheme.appbarIconsTheme,
        titleTextStyle: HorticadeTheme.appbarTitleTextStyle,
      ),
      backgroundColor: HorticadeTheme.scaffoldBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: formPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isNotEmpty ? null : "No e-mail provided",
                      decoration: textFieldDecoration('E-Mail'),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    formTextSpacer,
                    TextFormField(
                      validator: (val) =>
                          val!.isNotEmpty ? null : "No password provided",
                      decoration: textFieldDecoration('Password'),
                      obscureText: true,
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    formButtonSpacer,
                    _loading
                        ? Loader(
                            color: Colors.orange,
                            background: HorticadeTheme.scaffoldBackground!,
                          )
                        : ElevatedButton(
                            child: const Text(
                              'Login',
                              style: HorticadeTheme.actionButtonTextStyle,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                  _loginError = '';
                                });
                                AuthService.login(email, password)
                                    .then((error) {
                                  if (error != null) {
                                    setState(() {
                                      _loading = false;
                                      _loginError = error;
                                    });
                                  }
                                });
                              }
                            },
                            style: HorticadeTheme.actionButtonTheme,
                          ),
                    formButtonSpacer,
                    Text(_loginError, style: errorTextStyle),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
