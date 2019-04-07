import 'package:flutter/material.dart';

class AddToJarInput extends StatelessWidget {
  final String hint;
  final Function update;
  AddToJarInput({this.hint, this.update});
  @override
  Widget build(BuildContext context) {
    return Container(
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
        style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          errorStyle: TextStyle(color: Colors.red),
          hintText: hint,
          hintStyle: TextStyle(
              color:  Color.fromRGBO(131, 129, 129, 1), fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 5.0, right: 20.0, bottom: 20.0, left: 15.0),
        ),
        
        validator: (String val) {
          String finalVal = val.trim();
          if(hint == 'Name' && finalVal.isEmpty) {
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
