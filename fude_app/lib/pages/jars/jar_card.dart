import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar.dart';
import 'package:fude/helpers/design_helpers.dart';

class JarCard extends StatelessWidget {
  final MainModel model;
  final String jarTitle;
  final String jarID;
  final String jarImage;

  JarCard({this.jarTitle, this.jarID, this.jarImage, this.model});

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width;
    DocumentSnapshot jar = model.selectedJar;
    return Container(
      margin: EdgeInsets.all(8.0),
      width: containerWidth,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Color.fromRGBO(0, 0, 0, 0.9), BlendMode.dstATop),
            image: jarImage != null ? NetworkImage(jarImage) : logoInStorage()),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Color.fromRGBO(236, 240, 241, 1),
                onPressed: () {
                  print('jar pressed, $jarID');
                  model.getJarBySelectedId(jarID);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return JarPage();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Color.fromRGBO(236, 240, 241, 1),
                onPressed: () => print('favorite jar pressed'),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                jarTitle,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
