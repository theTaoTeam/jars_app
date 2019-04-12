import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/notes/notes_edit.dart';
import 'package:fude/pages/jars/jar_notes.dart';
import 'package:fude/pages/jars/jar.dart';

class NotePage extends StatelessWidget {
  final DocumentSnapshot note;
  final bool isRandom;

  NotePage({this.note, @required this.isRandom});

  Widget _buildTextSections(String val, BuildContext context, MainModel model,
      DocumentSnapshot note) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.5,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      child: val == note['link']
          ? GestureDetector(
              onTap: () => model.launchURL(val),
              child: Text(
                val,
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: Theme.of(context).textTheme.caption.fontSize,
                    letterSpacing:
                        Theme.of(context).textTheme.caption.letterSpacing),
              ))
          : Text(
              val,
              maxLines: val == "Notes" ? 3 : 1,
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: Theme.of(context).textTheme.caption.fontSize,
                  letterSpacing:
                      Theme.of(context).textTheme.caption.letterSpacing),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: !isRandom ? Icon(Icons.arrow_back_ios) : Icon(Icons.keyboard_arrow_down),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            iconSize: 40,
            onPressed: () => Navigator.pushReplacement(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: !isRandom ? PageTransitionType.leftToRightWithFade : PageTransitionType.upToDown,
                    child: !isRandom
                        ? JarNotes(model: model)
                        : JarPage(model: model),
                  ),
                ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).iconTheme.color,
              iconSize: 36,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.downToUp,
                    child: NoteEditPage(note: note),
                  ),
                );
              },
            )
          ],
        ),
        body: Container(
            height: height,
            width: width,
            // padding: EdgeInsets.all(25),
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: ListView(
              // shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
              children: <Widget>[
                Container(
                  height: height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(note['image'] != null
                          ? note['image']
                          : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604'),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.07),
                _buildTextSections(note['category'], context, model, note),
                SizedBox(height: height * 0.08),
                _buildTextSections(note['title'], context, model, note),
                SizedBox(height: height * 0.08),
                _buildTextSections(note['link'], context, model, note),
                SizedBox(height: height * 0.08),
                _buildTextSections(note['notes'], context, model, note),
              ],
            )),
      );
    });
  }
}
