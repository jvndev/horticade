import 'package:firebase/models/location.dart';
import 'package:firebase/screens/location/location_search.dart';
import 'package:firebase/services/auth.dart';
import 'package:firebase/shared/loader.dart';
import 'package:firebase/theme/horticade_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _registrationError = '';
  bool _loading = false;

  String email = '', password = '', passwordConfirm = '', name = '';
  Location? location;

  Future<void> register() async {
    setState(() {
      _registrationError = '';
    });

    if (location == null) {
      _registrationError = 'An address is required';
    } else {
      if (_formKey.currentState!.validate()) {
        _loading = true;
        String? response =
            await AuthService.register(name, location!, email, password);

        if (response != null) {
          setState(() {
            _loading = false;
            _registrationError = response;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Register"),
        actions: [
          IconButton(
            onPressed: () {
              widget.toggleView();
            },
            icon: const Icon(Icons.person),
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
                          val!.isEmpty ? 'Invalid business name' : null,
                      decoration: textFieldDecoration('Business Name'),
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                    formTextSpacer,
                    LocationSearch(onSelected: (val) => location = val),
                    formTextSpacer,
                    TextFormField(
                      validator: (val) =>
                          val!.isNotEmpty ? null : 'E-mail cannot be empty',
                      decoration: textFieldDecoration('E-Mail'),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    formTextSpacer,
                    TextFormField(
                      validator: (val) {
                        if (val!.length < 6) {
                          return 'Password not long enough';
                        }
                        if (val != passwordConfirm) {
                          return 'Password and Password Confirmation'
                              ' does not match';
                        }
                        return null;
                      },
                      decoration: textFieldDecoration('Password'),
                      obscureText: true,
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    formTextSpacer,
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? 'Password Confirmation required'
                          : null,
                      decoration: textFieldDecoration('Confirm Password'),
                      obscureText: true,
                      onChanged: (val) {
                        passwordConfirm = val;
                      },
                    ),
                    _loading
                        ? Loader(
                            color: Colors.orange,
                            background: HorticadeTheme.scaffoldBackground!,
                          )
                        : ElevatedButton(
                            onPressed: register,
                            child: const Text(
                              'Create User',
                              style: HorticadeTheme.actionButtonTextStyle,
                            ),
                            style: HorticadeTheme.actionButtonTheme,
                          ),
                    formButtonSpacer,
                    Text(_registrationError, style: errorTextStyle),
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
