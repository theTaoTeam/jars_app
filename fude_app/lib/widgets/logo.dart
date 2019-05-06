import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final DecorationImage image;
  Logo({this.image});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    
    return Container(
      width: 250.0,
      height: 250.0,
      padding: EdgeInsets.only(top: height * 0.07),
      alignment: Alignment.center,
      child: Text('JARS',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 60,
              letterSpacing: 8)),
    );
  }
}
