import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:jars/pages/auth/login/login.dart';
import 'package:jars/pages/auth/signup/signup.dart';
import 'package:jars/pages/auth/forgot-password/forgotpassword.dart';
import 'package:jars/pages/home/home.dart';
import 'package:jars/pages/jars/jar_add.dart';
import 'package:jars/pages/notes/notes_add.dart';
import 'package:jars/scoped-models/main.dart';
import 'package:jars/helpers/design_helpers.dart';

Future<void> main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainModel _model = MainModel();
    _model.fetchUser();
    _model.getThemeFromPrefs();
    return ScopedModel<MainModel>(
      model: _model,
      child: _buildApp(context),
    );
  }
}

Widget _buildApp(BuildContext context) {
  return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
    return MaterialApp(
      theme: buildAppThemeData(model.darkTheme),
      routes: {
        '/': (BuildContext context) =>
            model.currentUser != null ? HomePage(model: model) : LoginPage(),
        '/signup': (BuildContext context) => SignUpPage(),
        '/forgotpass': (BuildContext context) => ForgotPassPage(),
        '/addjar': (BuildContext context) => AddJarPage(),
        '/addnote': (BuildContext context) => AddNotePage(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        );
      },
    );
  });
}
