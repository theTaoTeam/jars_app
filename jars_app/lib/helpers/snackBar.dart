import 'package:flutter/material.dart';

void showSnackBar(GlobalKey<ScaffoldState> key) {
    final String errorMsg = '''
    Poor Network Connection.
    Wait for a better connection, or
    try closing and reopening the app.
    ''';
    final snackBar = SnackBar(
      backgroundColor: Color.fromRGBO(255, 51, 74, 1),
      elevation: 4,
      content: Text(errorMsg,
          style: TextStyle(color: Color.fromRGBO(242, 242, 242, 1))),
    );
    key.currentState.showSnackBar(snackBar);
  }