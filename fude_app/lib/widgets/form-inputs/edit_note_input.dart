import 'package:flutter/material.dart';

class EditNoteInput extends StatelessWidget {
  final String hint;
  final String initialVal;
  final Function update;
  EditNoteInput({this.hint, this.initialVal, this.update});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.05,
      // width: width * 0.85,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.5,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      child: TextFormField(
        maxLines: hint == "Notes" ? 3 : 1,
        initialValue: initialVal,
        style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: Theme.of(context).textTheme.caption.fontSize,
            letterSpacing: Theme.of(context).textTheme.caption.letterSpacing),
        decoration: InputDecoration(
          suffix: null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              color: Color.fromRGBO(131, 129, 129, 1),
              fontSize: Theme.of(context).textTheme.caption.fontSize),
          contentPadding:
              EdgeInsets.fromLTRB(height * 0.02, height * 0.01, 0, 0),
          errorStyle: TextStyle(
              color: Colors.red,
              fontSize: 12,
              letterSpacing: Theme.of(context).textTheme.caption.letterSpacing),
        ),
        validator: (String val) {
          String finalVal = val.trim();
          if (hint == 'Name' && finalVal.isEmpty) {
            return 'Please give your idea a name';
          }
        },
        onSaved: (String val) {
          if (hint != null) {
            update(val);
          }
        },
      ),
    );
  }
}
