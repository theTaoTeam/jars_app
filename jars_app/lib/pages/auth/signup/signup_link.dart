import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.only(
        top: 160.0,
      ),
      onPressed: () => Navigator.pushNamed(context, '/signup'),
      child: Text(
        "Don't have an account? Sign Up",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
            color: Theme.of(context).primaryColor,
            fontSize: 12.0),
      ),
    );
  }
}
