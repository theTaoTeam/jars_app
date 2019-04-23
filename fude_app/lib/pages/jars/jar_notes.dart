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
  var stream; // state variable

  @override
  void initState() {
    super.initState();
  }

  void toggleFavoriteFilter() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void toggleFavoriteStatus(DocumentSnapshot note) {
    setState(() {
      widget.model.toggleFavoriteStatus(note);
    });
  }

  _buildNoteListItem(BuildContext context, DocumentSnapshot document) {
    return NotesCard(
        note: document, toggleFavoriteStatus: toggleFavoriteStatus);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    DocumentSnapshot jar = widget.model.selectedJar;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.pushReplacement(
                context,
                PageTransition(
                  curve: Curves.linear,
                  type: PageTransitionType.leftToRightWithFade,
                  child: JarPage(model: widget.model),
                ),
              ),
          iconSize: Theme.of(context).iconTheme.size,
          color: Theme.of(context).iconTheme.color,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(
              right: width * 0.04,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.add),
              iconSize: Theme.of(context).iconTheme.size,
              color: Theme.of(context).iconTheme.color,
              onPressed: () => Navigator.pushReplacement(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.downToUp,
                      child: AddNotePage(
                          categories:
                              widget.model.selectedJar.data['categories']),
                    ),
                  ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
        child: StreamBuilder(
            stream: !isFavorite
                ? Firestore.instance
                    .collection('jars')
                    .document(jar.documentID)
                    .collection('jarNotes')
                    .snapshots()
                : Firestore.instance
                    .collection('jars')
                    .document(jar.documentID)
                    .collection('jarNotes')
                    .where('isFav', isEqualTo: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print('snapshot hasData: ${snapshot.hasData}');
                return Center(child: CircularProgressIndicator());
              } else {
                return snapshot.data.documents.length > 0
                    ? Column(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.05, 0, 0, height * 0.02),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          !isFavorite
                                              ? 'ALL IDEAS'
                                              : 'FAVORITE IDEAS',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                131, 129, 129, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 5,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          ListView.builder(
                              shrinkWrap: true,
                              reverse: false,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildNoteListItem(
                                    context, snapshot.data.documents[index]);
                              }),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    0, 0, width * 0.04, width * 0.05),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: isFavorite
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border),
                                  iconSize: 38,
                                  color: Theme.of(context).iconTheme.color,
                                  onPressed: () => toggleFavoriteFilter(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'ADD AN IDEA TO GET STARTED',
                          style: Theme.of(context).textTheme.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      );
              }
            }),
      ),
    );
  }
}
