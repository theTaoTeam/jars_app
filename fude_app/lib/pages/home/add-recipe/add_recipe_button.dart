import 'package:flutter/material.dart';

import 'package:fude/scoped-models/main.dart';

class AddRecipeButton extends StatelessWidget {
  final MainModel model;

  AddRecipeButton({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('add recipe tapped');
        
      },
      child: Container(
        width: 320.0,
        height: 60.0,
        margin: EdgeInsets.only(top: 20),
        alignment: FractionalOffset.center,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(247, 64, 106, 1.0),
          borderRadius: BorderRadius.all(const Radius.circular(30.0)),
        ),
        child: Text(
          "add recipe",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
