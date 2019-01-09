import 'package:flutter/material.dart';

import 'package:fude/pages/auth/login/login.dart';
import 'package:fude/pages/add-recipe/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Colors.white,
        primaryColor: Colors.black,
      ),
      routes: {
        '/': (BuildContext context) => LoginPage(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginPage(),
        );
      },
    );
  }
}
