import 'package:flutter/material.dart';

class BackToLogin extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return FlatButton(
      padding: EdgeInsets.only(
        top: 100.0,
      ),
      onPressed: () => Navigator.pop(context),
      child: Text(
        "Back to login",
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
