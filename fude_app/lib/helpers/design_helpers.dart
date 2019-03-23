import 'package:flutter/material.dart';

NetworkImage logoInStorage() {
  return NetworkImage(
      'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
      scale: 0.1);
}

Widget buildDivider({String title}) {
  return Container(
    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Divider(
            height: 20,
            color: Colors.black,
          ),
        ),
        Text('        $title        '),
        Expanded(
          child: Divider(
            height: 20,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
