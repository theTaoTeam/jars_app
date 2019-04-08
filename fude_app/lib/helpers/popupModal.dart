import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/notes/note.dart';

void showRandomNote(BuildContext context, DocumentSnapshot randomNote,
    MainModel model, String category) {
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: Container(
          width: width,
          height: randomNote != null ? height * 0.4 : height * 0.09,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog centre
              randomNote != null
                  ? Expanded(
                      child: Container(
                        child: Image.network(
                          randomNote['image'] != null
                              ? randomNote['image']
                              : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
                        ),
                      ),
                      flex: 2,
                    )
                  : Container(),
              // dialog top
              randomNote != null
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Text(
                              randomNote['title'].toUpperCase(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        Container(
                          height: 15,
                        ),
                        Text(
                          "You don't have any $category ideas yet.",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ),
              // dialog bottom
              randomNote != null
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                // color: Color(0xFF33b17c),
                                ),
                            child: FlatButton(
                                child: Text(
                                  'OPEN',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      curve: Curves.linear,
                                      type: PageTransitionType.downToUp,
                                      child: NotePage(
                                        note: randomNote,
                                        isRandom: false,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    },
  );
}
