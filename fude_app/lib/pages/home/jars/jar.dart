import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/design_helpers.dart';
import 'package:fude/pages/home/notes/all-notes/all_notes.dart';
import 'package:fude/pages/home/notes/notes_add.dart';

class JarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<JarPage> {
  bool isFavorite = false;

  void toggleFavoriteFilter() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(33, 38, 43, 0.6), BlendMode.darken),
                image: model.selectedJar.data['image'] != null
                    ? NetworkImage(model.selectedJar.data['image'])
                    : logoInStorage()),
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                Color.fromRGBO(235, 237, 238, 1),
                Color.fromRGBO(253, 251, 251, 1),
              ],
            ),
          ),
          child: CustomScrollView(
            shrinkWrap: true,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                pinned: true,
                expandedHeight: 650.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(model.selectedJar.data['title']),
                  collapseMode: CollapseMode.parallax,
                  centerTitle: false,
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 40,
                    color: Color.fromRGBO(236, 240, 241, 1),
                    onPressed: () => Navigator.pushNamed(context, '/addnote'),
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AllNotes(
                          model: model,
                          isFavorite: isFavorite,
                          toggleFavoriteFilter: toggleFavoriteFilter)
                    ],
                  )
                ]),
              )
            ],
          ),
        ),
      );
    });
  }
}
