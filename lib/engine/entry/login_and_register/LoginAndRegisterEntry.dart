import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid/engine/entry/login_and_register/LoginAndRegisterWidget.dart';

class LoginAndRegisterEntry extends StatefulWidget {
  @override
  _LoginAndRegisterEntryState createState() => _LoginAndRegisterEntryState();
}

class _LoginAndRegisterEntryState extends State<LoginAndRegisterEntry> {
  @override
  Widget build(BuildContext context) {
    print('${this.hashCode} _LoginAndRegisterEntryState build');
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: LoginAndRegisterWidget(),
      ),
    );
  }
}
