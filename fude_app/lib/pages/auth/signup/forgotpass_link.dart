import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlatButton(
          padding: const EdgeInsets.only(
            top: 160.0,
          ),
          onPressed: () {
            print('reset password pressed');
          },
          child: new Text(
            "Forgot your password? Reset it!",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: new TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: Colors.white,
                fontSize: 12.0),
          ),
        ),
      ],
    );
  }
}
