import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/home/notes/notes_card.dart';
import 'package:fude/pages/home/notes/notes_add.dart';
import 'package:fude/pages/home/jars/jar.dart';
import 'package:fude/scoped-models/main.dart';

class JarNotes extends StatefulWidget {
  final MainModel model;

  JarNotes({this.model});

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
    if (document != null) {
      if (isFavorite) {
        if (document.data['isFav']) {
          return NotesCard(note: document, model: widget.model);
        }
      } else {
        return NotesCard(note: document, model: widget.model);
      }
    } else {
      return Text('add a note to get started!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    DocumentSnapshot jar = widget.model.selectedJar;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Color.fromRGBO(236, 240, 241, 1),
        elevation: 0,
        title: GestureDetector(
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Icon%20Dark.png?alt=media&token=717822bd-3e49-46e7-b7d8-1b432afd3e50',
            height: height * 0.2,
            width: width * 0.2,
          ),
          onTap: () => print('invert theme pressed'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => Navigator.pop(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.upToDown,
                    child: JarPage(),
                  ),
                ),
            color: Colors.black,
            iconSize: 42,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.fade,
                child: AddNotePage(
                    categories: widget.model.selectedJar.data['categories']),
              ),
            ),
        tooltip: 'ADD ${widget.model.selectedJar.data['title']} IDEA',
        child: Icon(Icons.add),
        elevation: 2.0,
        backgroundColor: Colors.black,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(236, 240, 241, 1),
        elevation: 0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 0.3,
            ),
            Container(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: isFavorite
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                iconSize: 30,
                color: Color.fromRGBO(33, 38, 43, 1),
                onPressed: () => toggleFavoriteFilter(),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(236, 240, 241, 1),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
                print('returning listview.builder...');
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(width: width * .20),
                      ],
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(top: 25),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildNoteListItem(
                            context, snapshot.data.documents[index]);
                      },
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
