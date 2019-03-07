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
          bottom: BorderSide(
            width: 0.5,
            color: Colors.black,
          ),
        ),
        color: Color.fromRGBO(0, 0, 0, 0.1)
      ),
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black, fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 20.0, right: 20.0, bottom: 20.0, left: 5.0),
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
