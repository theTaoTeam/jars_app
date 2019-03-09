import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/notes_card.dart';
import 'package:fude/scoped-models/main.dart';

class AllNotes extends StatelessWidget {
  final DocumentSnapshot jar;
  final MainModel model;

  AllNotes({this.jar, this.model});

  _buildNoteListItem(BuildContext context, DocumentSnapshot document) {
    return NotesCard(note: document, model: model);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: StreamBuilder(
          stream: Firestore.instance.collection('jars').document(jar.documentID).collection('jarNotes').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print('snapshot hasData: ${snapshot.hasData}');
              return Center(child: CircularProgressIndicator());
            } else {
              print('returning listview.builder...');
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildNoteListItem(
                      context, snapshot.data.documents[index]);
                },
              );
            }
          }),
    );
  }
}
