import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final DecorationImage image;
  Logo({this.image});
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 250.0,
      height: 250.0,
      alignment: Alignment.center,
      child: Text('JARS',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 60,
              letterSpacing: 8)),
    );
  }
}
