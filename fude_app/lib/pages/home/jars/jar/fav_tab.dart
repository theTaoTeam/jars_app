import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/helpers/design_helpers.dart';
import 'package:fude/pages/home/jars/jar/jar_banner.dart';
import 'package:fude/pages/home/jars/jar/fav_notes.dart';
import 'package:fude/scoped-models/main.dart';

class FavTab extends StatelessWidget {
  final MainModel model;
  final DocumentSnapshot jar;

  FavTab({this.jar, this.model});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Color.fromRGBO(0, 0, 0, 0.15), BlendMode.dstATop),
          image: AssetImage('assets/logo.png'),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: <Widget>[
          JarBanner(title: jar['title']),
          buildDivider(title: 'favorites'),
          FavNotes(jar: jar, model: model),
        ],
      ),
    );
  }
}
