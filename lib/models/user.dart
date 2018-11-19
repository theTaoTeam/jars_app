import 'package:flutter/material.dart';

class User {
  final String uid;
  final String email;
  final String token;
  final bool darkTheme;

  User({@required this.uid, @required this.email, @required this.token, @required this.darkTheme});
}
