import 'package:flutter/material.dart';

class EditNoteInput extends StatelessWidget {
  final String hint;
  final String initialVal;
  final Function updateTitle;
  final Function updateLink;
  final Function updateNotes;
  EditNoteInput(
      {this.hint, this.initialVal, this.updateTitle, this.updateLink, this.updateNotes});
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
        initialValue: initialVal,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(0, 0, 0, 0.8),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 20.0, right: 20.0, bottom: 5.0, left: 5.0),
          
        ),
        onSaved: (String val) {
          if (hint == 'Title') {
            updateTitle(val);
          } else if (hint == 'Link') {
            updateLink(val);
          } else if (hint == 'Notes') {
            updateNotes(val);
          }
        },
      ),
    );
  }
}