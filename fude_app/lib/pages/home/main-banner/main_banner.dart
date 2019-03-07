import 'package:flutter/material.dart';

class MainBanner extends StatelessWidget {
  final String title;

  MainBanner({this.title});

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
            Text(title)
          ],
        ));
  }
}
