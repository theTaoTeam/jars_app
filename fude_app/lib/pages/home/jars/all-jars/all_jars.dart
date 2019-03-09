import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/all-jars/jar_icon.dart';

class AllJars extends StatelessWidget {
  final MainModel model;

  AllJars({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: StreamBuilder(
          stream: Firestore.instance.collection('jars').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // print('snapshot hasData: ${snapshot.hasData}');
              return Center(child: CircularProgressIndicator());
            } else {
              // print('AllJars listview.builder...');        
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
                      jarTitle: snapshot.data.documents[index]['title'], jarId: snapshot.data.documents[index].documentID, model: model);
                },
              );
            }
          }),
    );
  }
}
