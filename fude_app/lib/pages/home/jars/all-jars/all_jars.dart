import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/all-jars/jar_icon.dart';

class AllJars extends StatelessWidget {
  final MainModel model;

  AllJars({this.model});

  Widget _buildAllJarsRows(
      BuildContext context, List<DocumentSnapshot> jars, double deviceWidth) {
    List<JarIcon> jarIconList;

    jars.forEach((jar) {
      jarIconList.add(JarIcon(jarTitle: jar['title']));
    });

    return Container(
        padding: EdgeInsets.all(10),
        width: deviceWidth,
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('jars').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // print('snapshot hasData: ${snapshot.hasData}');
            return Center(child: CircularProgressIndicator());
          } else {
            print('AllJars listview.builder...');
            return GridView.builder(
              shrinkWrap: true,
              addSemanticIndexes: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return JarIcon(
                    jarTitle: snapshot.data.documents[index]['title']);
              },
            );
          }
        });
  }
}
