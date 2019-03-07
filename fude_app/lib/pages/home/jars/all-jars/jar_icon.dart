import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/pages/home/jars/jar/jar.dart';
import 'package:fude/scoped-models/main.dart';

class JarIcon extends StatelessWidget {
  final String jarTitle;
  final String jarId;

  JarIcon({this.jarTitle, this.jarId});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        height: deviceHeight * 0.05,
        width: deviceWidth * 0.05,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Column(
          children: <Widget>[
            IconButton(
              iconSize: 20,
              icon: Icon(Icons.check_circle),
              color: Theme.of(context).accentColor,
              onPressed: () {
                print('jar pressed, $jarId');
                model.getJarBySelectedId(jarId);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return JarPage(model: model);
                    },
                  ),
                );
              },
            ),
            Text(jarTitle),
          ],
        ),
      );
    });
  }
}
