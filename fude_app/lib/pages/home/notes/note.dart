import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/notes/notes_edit.dart';
import 'package:fude/pages/home/jars/jar_notes.dart';
import 'package:fude/pages/home/jars/jar.dart';

class NotePage extends StatelessWidget {
  final DocumentSnapshot note;
  final bool isRandom;

  NotePage({this.note, @required this.isRandom});

  Widget _buildTextSections(String val) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.5,
            color: Color.fromRGBO(236, 240, 241, 1),
          ),
        ),
      ),
      child: Text(
        val,
        maxLines: val == "Notes" ? 3 : 1,
        style: TextStyle(color: Color.fromRGBO(236, 240, 241, 1), fontSize: 20),
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
          backgroundColor: Color.fromRGBO(33, 38, 43, 1),
          title: GestureDetector(
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Icon%20Dark.png?alt=media&token=717822bd-3e49-46e7-b7d8-1b432afd3e50',
              height: height * 0.2,
              width: width * 0.2,
            ),
            onTap: () => print('invert theme pressed'),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            iconSize: 30,
            onPressed: () => Navigator.pushReplacement(
                  context,
                  PageTransition(
                    curve: Curves.linear,
                    type: PageTransitionType.leftToRightWithFade,
                    child: !isRandom ? JarNotes(model: model) : JarPage(model: model),
                  ),
                ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
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
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.bottomCenter,
                end: FractionalOffset.topCenter,
                colors: [
                  Color.fromRGBO(33, 38, 43, 0.7),
                  Color.fromRGBO(33, 38, 43, 1),
                ],
              ),
            ),
            child: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: height / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: NetworkImage(note['image'] != null
                        ? note['image']
                        : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604'),
                  )),
                ),
                _buildTextSections(note['category']),
                SizedBox(height: 30),
                _buildTextSections(note['title']),
                SizedBox(height: 30),
                _buildTextSections(note['link']),
                SizedBox(height: 30),
                _buildTextSections(note['notes']),
              ],
            )),
      );
    });
  }
}
