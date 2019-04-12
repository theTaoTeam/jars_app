import 'package:flutter/material.dart';

import 'package:fude/scoped-models/main.dart';

class AddJarCategoryField extends StatelessWidget {
  final String hint;
  final Function updateCategory;
  final MainModel model;

  AddJarCategoryField({this.hint, this.updateCategory, this.model});
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
        initialValue: hint != "Category" ? hint : null,
        style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color:  Color.fromRGBO(131, 129, 129, 1), fontSize: 15.0),
          contentPadding:
              EdgeInsets.only(top: 5.0, right: 20.0, bottom: 20.0, left: 15.0),
        ),
        validator: (String val) {
          String finalVal = val.trim();
          if(finalVal.isEmpty) {
            return 'Please add at least one category ';
          }
        },
        onSaved: (String val) {
          if (hint != null) {
          String finalVal = val.trim();
            updateCategory(finalVal);
          }
        },
      ),
    );
  }
}
