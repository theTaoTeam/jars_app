import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/notes/note.dart';
import 'package:fude/helpers/design_helpers.dart';

class NotesCard extends StatelessWidget {
  final DocumentSnapshot note;
  final Function toggleFavoriteStatus;

  NotesCard({this.note, this.toggleFavoriteStatus});

  Widget makeListTile(DocumentSnapshot note, double _targetWidth, double height,
      BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      leading: Container(
        width: _targetWidth * 0.55,
        // height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: note['image'] != null
              ? Image.network(note['image'], scale: 0.1)
              : logoInStorage(),
        ),
      ),
      title: Container(
        child: Text(
          note['title'].toUpperCase(),
          style: Theme.of(context).textTheme.headline,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(top: 5),
        child: Text(
          note['category'].toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      trailing: IconButton(
        icon:
            !note['isFav'] ? Icon(Icons.favorite_border) : Icon(Icons.favorite),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Theme.of(context).primaryColor,
        iconSize: 24,
        onPressed: () => toggleFavoriteStatus(note),
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
            type: PageTransitionType.rightToLeftWithFade,
            child: NotePage(
              note: note,
              isRandom: false,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor,
              blurRadius: 20.0,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          color: Theme.of(context).cardColor,
          elevation: 6.0,
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: makeListTile(note, _targetWidth, height, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
