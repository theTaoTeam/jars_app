import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/helpers/design_helpers.dart';
import 'package:fude/pages/home/jars/jar_banner.dart';
import 'package:fude/pages/home/notes/all-notes/all_notes.dart';
import 'package:fude/scoped-models/main.dart';

class AllNotesTab extends StatelessWidget {
  final DocumentSnapshot jar;
  final MainModel model;


  AllNotesTab({this.model, this.jar});

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
          buildDivider(title: 'all'),
          AllNotes(model: model),
        ],
      ),
    );
  }
}
