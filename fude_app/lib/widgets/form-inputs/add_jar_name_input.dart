import 'package:flutter/material.dart';

class AddJarNameField extends StatelessWidget {
  final String hint;
  final Function updateTitle;
  AddJarNameField({this.hint, this.updateTitle});
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
        initialValue: hint != "Name" ? hint : null,
        style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: Theme.of(context).textTheme.caption.fontSize,
            letterSpacing: Theme.of(context).textTheme.caption.letterSpacing),
        decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Theme.of(context).secondaryHeaderColor,
          hintText: hint,
          hintStyle: TextStyle(
              color: Color.fromRGBO(131, 129, 129, 1), fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 5.0, right: 20.0, bottom: 20.0, left: 15.0),
        ),
        validator: (String val) {
          String finalVal = val.trim();
          if (finalVal.isEmpty) {
            // print('val empty');
            return 'Please give your jar a name';
          }
        },
        onSaved: (String val) {
          if (hint != null) {
            String finalVal = val.trim();
            updateTitle(finalVal);
          }
        },
      ),
    );
  }
}
