import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/home/notes/note.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/design_helpers.dart';

class NotesCard extends StatelessWidget {
  final DocumentSnapshot note;
  final MainModel model;

  NotesCard({this.note, this.model});

  Widget makeListTile(
      DocumentSnapshot note, double _targetWidth, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Colors.white24),
          ),
        ),
        child: Container(
          width: _targetWidth * 0.5,
          child: note['image'] != null
              ? Image.network(note['image'], scale: 0.1)
              : logoInStorage(),
        ),
      ),
      title: Text(
        note['title'],
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(note['category'], style: TextStyle(color: Colors.white))
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
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
            type: PageTransitionType.rightToLeftWithFade,
            child: NotePage(note: note, isRandom: false,),
          ),
        );
      },
      child: Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(64, 75, 96, .9),
          ),
          child: makeListTile(note, _targetWidth, context),
        ),
      ),
    );
  }
}
