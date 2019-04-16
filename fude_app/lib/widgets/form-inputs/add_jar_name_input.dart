import 'package:flutter/material.dart';

class AddJarNameField extends StatelessWidget {
  final String hint;
  final Function updateTitle;
  AddJarNameField({this.hint, this.updateTitle});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.05,
      width: width * 0.85,
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
          suffix: null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              color: Color.fromRGBO(131, 129, 129, 1),
              fontSize: Theme.of(context).textTheme.caption.fontSize),
          contentPadding: EdgeInsets.fromLTRB(height * 0.02, height * 0.01, 0, 0),
          errorStyle: TextStyle(
              color: Colors.red,
              fontSize: Theme.of(context).textTheme.caption.fontSize,
              letterSpacing: Theme.of(context).textTheme.caption.letterSpacing),
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
