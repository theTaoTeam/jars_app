import 'package:flutter/material.dart';

class JarIcon extends StatelessWidget {
  final String jarTitle;

  JarIcon({this.jarTitle});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.width;
    return Container(
      height: deviceHeight * 0.05,
      width: deviceWidth * 0.05,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: <Widget>[
          IconButton(
            iconSize: 20,
            icon: Icon(Icons.check_circle),
            color: Theme.of(context).accentColor,
            onPressed: () {
              print('jar pressed');
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (BuildContext context) {
              //       return RecipeEditPage();
              //     },
              //   ),
              // );
            },
          ),
          Text(jarTitle),
        ],
      ),
    );
  }
}
