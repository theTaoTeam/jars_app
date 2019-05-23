import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fude/scoped-models/main.dart';

import 'package:fude/models/idea.dart';
import 'package:fude/pages/notes/note.dart';

class NotesCard extends StatelessWidget {
  final Idea idea;
  final MainModel model;
  final Function toggleFavoriteStatus;
  final int index;

  NotesCard({this.idea, this.toggleFavoriteStatus, this.model, this.index});

  Widget makeListTile(
      Idea idea, double _targetWidth, double height, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: Container(
        width: _targetWidth * 0.25,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(1.0),
          child: idea.image != null
              ? idea.image.runtimeType != String
                  ? Image.file(
                      idea.image,
                      fit: BoxFit.cover,
                      alignment: FractionalOffset(
                        0.5,
                        0.5,
                      ),
                    )
                  : Image.network(idea.image, scale: 0.2)
              : Image.network(
                  model.locallySelJar.image,
                  scale: 1,
                ),
        ),
      ),
      title: Container(
        child: Text(
          idea.title.toUpperCase(),
          style: Theme.of(context).textTheme.headline,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      subtitle: Container(
        margin: EdgeInsets.only(top: 5),
        child: Text(
          idea.category.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      trailing: IconButton(
        icon:
            !idea.getIsFav ? Icon(Icons.favorite_border) : Icon(Icons.favorite),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Theme.of(context).primaryColor,
        iconSize: 24,
        onPressed: () => toggleFavoriteStatus(idea, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // print(idea.getIsFav);
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            curve: Curves.linear,
            type: PageTransitionType.rightToLeftWithFade,
            child: NotePage(
              idea: idea,
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
                child: makeListTile(idea, width, height, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
