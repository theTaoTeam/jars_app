import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/notes_card.dart';
import 'package:fude/scoped-models/main.dart';

class AllNotes extends StatelessWidget {
  final MainModel model;
  final bool isFavorite;
  final Function toggleFavoriteFilter;

  AllNotes({this.model, this.isFavorite, this.toggleFavoriteFilter});

  _buildNoteListItem(BuildContext context, DocumentSnapshot document) {
    if (document != null) {
      if (isFavorite) {
        if (document.data['isFav']) {
          return NotesCard(note: document, model: model);
        }
      } else {
        return NotesCard(note: document, model: model);
      }
    } else {
      return Text('add a note to get started!');
    }
  }

  @override
  Widget build(BuildContext context) {
    DocumentSnapshot jar = model.selectedJar;
    return Container(
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
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      '_____',
                      style: TextStyle(
                        fontSize: 34,
                        color: Color.fromRGBO(33, 38, 43, 0.7),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: isFavorite
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        iconSize: 30,
                        color: Color.fromRGBO(33, 38, 43, 1),
                        onPressed: () => toggleFavoriteFilter(),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
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
    );
  }
}
