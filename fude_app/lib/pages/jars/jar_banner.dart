import 'package:flutter/material.dart';

class JarBanner extends StatelessWidget {
  final String title;

  JarBanner({this.title});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.width;
    return Container(
        height: deviceHeight * 0.75,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$title Jar')
          ],
        ));
  }
}
