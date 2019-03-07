import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/jar/jar_banner.dart';
import 'package:fude/pages/home/jars/jar/jar_recipes.dart';
import 'package:fude/widgets/side_drawer.dart';

class JarPage extends StatelessWidget {
  final MainModel model;

  JarPage({this.model});

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot jar = model.selectedJar;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(jar['title']),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(175, 31, 82, 1),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      drawer: buildSideDrawer(context, model),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.red,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Container(
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
          children: <Widget>[JarBanner(categories: jar['categories'],), JarRecipes(jar: jar)],
        ),
      ),
    );
  }
}
