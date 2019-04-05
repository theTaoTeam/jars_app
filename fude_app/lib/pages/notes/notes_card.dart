import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/notes/note.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/design_helpers.dart';

class NotesCard extends StatelessWidget {
  final DocumentSnapshot note;
  final MainModel model;

  NotesCard({this.note, this.model});

  Widget makeListTile(
      DocumentSnapshot note, double _targetWidth, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 00.0, vertical: 15.0),
      leading: Container(
        width: _targetWidth * 0.55,
        child: note['image'] != null
            ? Image.network(note['image'], scale: 0.1)
            : logoInStorage(),
      ),
      title: Container(
        child: Text(
          note['title'].toUpperCase(),
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      subtitle: Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(note['category'].toUpperCase(),
              style: TextStyle(color: Colors.black, fontSize: 16))),
      trailing: IconButton(
        icon:
            !note['isFav'] ? Icon(Icons.favorite_border) : Icon(Icons.favorite),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () => model.toggleFavoriteStatus(note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double _targetWidth = width > 550.0 ? 100.0 : width * 0.45;
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            curve: Curves.linear,
            type: PageTransitionType.downToUp,
            child: NotePage(
              note: note,
              isRandom: false,
            ),
          ),
        );
      },
      child: Card(
        color: Color.fromRGBO(253, 251, 251, 1),
        elevation: 6.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: makeListTile(note, _targetWidth, context),
            ),
          ],
        ),
      ),
    );
  }
}
