import 'package:flutter/material.dart';

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