import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/notes/notes_card.dart';
import 'package:fude/pages/notes/notes_add.dart';
import 'package:fude/pages/jars/jar.dart';
import 'package:fude/scoped-models/main.dart';

class JarNotes extends StatefulWidget {
  final MainModel model;

  JarNotes({@required this.model});

  @override
  State<StatefulWidget> createState() {
    return _JarNotesState();
  }
}

class _JarNotesState extends State<JarNotes> {
  bool isFavorite = false;

  void toggleFavoriteFilter() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  _buildNoteListItem(BuildContext context, DocumentSnapshot document) {
    return NotesCard(note: document, model: widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    DocumentSnapshot jar = widget.model.selectedJar;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.pushReplacement(
                context,
                PageTransition(
                  curve: Curves.linear,
                  type: PageTransitionType.rightToLeftWithFade,
                  child: JarPage(model: widget.model),
                ),
              ),
          color: Colors.black,
          iconSize: 40,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(
              right: width * 0.025,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.add),
              iconSize: 35,
              color: Color.fromRGBO(33, 38, 43, 1),
              onPressed: () => Navigator.push(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.fade,
                      child: AddNotePage(
                          categories:
                              widget.model.selectedJar.data['categories']),
                    ),
                  ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: width * 0.03,
            ),
            child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon:
                isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
            iconSize: 30,
            color: Color.fromRGBO(33, 38, 43, 1),
            onPressed: () => toggleFavoriteFilter(),
          ),),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color.fromRGBO(253, 251, 251, 1),
                Color.fromRGBO(235, 237, 238, 1),
              ]),
        ),
        padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('jars')
                .document(jar.documentID)
                .collection('jarNotes')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print('snapshot hasData: ${snapshot.hasData}');
                return Center(child: CircularProgressIndicator());
              } else {
                return snapshot.data.documents.length > 0
                    ? Column(
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (isFavorite) {
                                if (snapshot.data.documents[index]['isFav']) {
                                  return _buildNoteListItem(
                                      context, snapshot.data.documents[index]);
                                }
                              } else {
                                return _buildNoteListItem(
                                    context, snapshot.data.documents[index]);
                              }
                            },
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                  height: height * 0.15,
                                  // width: width,
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.04, 0, width * 0.025, 0.15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        !isFavorite
                                            ? 'ALL IDEAS'
                                            : 'FAVORITE IDEAS',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text('ADD AN IDEA TO GET STARTED'),
                      );
              }
            }),
      ),
    );
  }
}
