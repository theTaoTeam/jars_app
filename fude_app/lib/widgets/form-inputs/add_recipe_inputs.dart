import 'package:flutter/material.dart';

class AddRecipeInput extends StatelessWidget {
  final String hint;
  final Function updateTitle;
  final Function updateLink;
  final Function updateNotes;
  AddRecipeInput(
      {this.hint, this.updateTitle, this.updateLink, this.updateNotes});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
        onSaved: (String val) {
          print(val);
          if(hint == 'Title') {
            updateTitle(val);
          } else if(hint == 'Link') {
            updateLink(val);
          } else if(hint == 'Notes') {
            updateNotes(val);
          }
        },
      ),
    );
  }
}
