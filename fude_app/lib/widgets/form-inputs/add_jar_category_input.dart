import 'package:flutter/material.dart';

class AddJarCategoryField extends StatelessWidget {
  final String hint;
  final Function updateCategory;
  AddJarCategoryField({this.hint, this.updateCategory});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.5,
            color: Color.fromRGBO(236, 240, 241, 1),
          ),
        ),
      ),
      child: TextFormField(
        style: TextStyle(
          color: Color.fromRGBO(236, 240, 241, 1),
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Color.fromRGBO(236, 240, 241, 0.7), fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 5.0, right: 20.0, bottom: 20.0, left: 15.0),
        ),
        onSaved: (String val) {
          if (hint == 'Category') {
            updateCategory(val);
          }
        },
      ),
    );
  }
}
