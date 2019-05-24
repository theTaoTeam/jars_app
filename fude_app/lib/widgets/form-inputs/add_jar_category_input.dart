import 'package:flutter/material.dart';

import 'package:jars/scoped-models/main.dart';

class AddJarCategoryField extends StatelessWidget {
  final String hint;
  final bool enabled;
  final Function updateCategory;
  final Function addCategoryToRemoveList;
  final MainModel model;
  final List<dynamic> categories;

  AddJarCategoryField(
      {this.hint,
      this.enabled,
      this.updateCategory,
      this.addCategoryToRemoveList,
      this.model,
      this.categories});
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onLongPress: () => hint != 'ALL' ? addCategoryToRemoveList(hint) : print("you can't delete the all category"),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 6.0,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: height * 0.08,
          width: width * 0.55,
          child: TextFormField(
            controller: TextEditingController(
                text: hint != "Add Category" ? hint : null),
            textAlign: TextAlign.start,
            enabled: enabled,
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: Theme.of(context).textTheme.caption.fontSize,
                letterSpacing:
                    Theme.of(context).textTheme.caption.letterSpacing),
            decoration: InputDecoration(
              suffix: null,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: Color.fromRGBO(131, 129, 129, 1),
                  fontSize: Theme.of(context).textTheme.caption.fontSize),
              contentPadding:
                  EdgeInsets.fromLTRB(height * 0.02, height * 0.03, 0, 0),
              errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: Theme.of(context).textTheme.caption.fontSize,
                  letterSpacing:
                      Theme.of(context).textTheme.caption.letterSpacing),
            ),
            validator: (String val) {
              String finalVal = val.trim();
              if (finalVal.isEmpty) {
                return 'cannot be blank';
              }
            },
            onSaved: (String val) {
              if (hint == 'Add Category') {
                String finalVal = val.trim();
                updateCategory(finalVal);
              }
            },
          ),
        ),
      ),
    );
  }
}
