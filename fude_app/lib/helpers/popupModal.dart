import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';

void showRandomNote(
    BuildContext context, DocumentSnapshot randomNote, MainModel model) {
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
          height: height * 0.4,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog centre
              Expanded(
                child: Container(
                  child: Image.network(
                    randomNote['image'] != null
                        ? randomNote['image']
                        : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
                  ),
                ),
                flex: 2,
              ),
              // dialog top
              Expanded(
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
              ),
              // dialog bottom
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          // color: Color(0xFF33b17c),
                          ),
                      child: FlatButton(
                        child: Text(
                          'CLOSE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
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
                        onPressed: () => randomNote['link'] != null ? model.launchURL(randomNote['link']) : Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
