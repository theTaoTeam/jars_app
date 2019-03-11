import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/side_drawer.dart';
import 'package:fude/pages/home/jars/jar/fav_tab.dart';
import 'package:fude/pages/home/jars/jar/all_notes_tab.dart';
import 'package:fude/pages/home/add-note/add_note.dart';

class JarPage extends StatelessWidget {
  final MainModel model;

  JarPage({this.model});

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot jar = model.selectedJar;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color.fromRGBO(175, 31, 82, 1),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.list),
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                ),
              ],
            ),
          ),
          drawer: buildSideDrawer(context, model),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddNotePage(categories: jar['categories'])),
                ),
          ),
          body: TabBarView(
            children: <Widget>[
              AllNotesTab(jar: jar, model: model),
              FavTab(jar: jar, model: model),
            ],
          )),
    );
  }
}
