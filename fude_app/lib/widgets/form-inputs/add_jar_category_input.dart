import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:fude/scoped-models/main.dart';

class AddJarCategoryField extends StatelessWidget {
  final String hint;
  final bool enabled;
  final bool needsAtLeastOneCategory;
  final Function updateCategory;
  final Function removeCategory;
  final MainModel model;

  AddJarCategoryField({
    this.hint,
    this.enabled,
    this.needsAtLeastOneCategory,
    this.updateCategory,
    this.removeCategory,
    this.model,
  });
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('Input Hint: $hint');
    return GestureDetector(
      onLongPress: () => removeCategory(hint),
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 6.0,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: height * 0.085,
          width: width * 0.55,
          child: TextFormField(
            textAlign: TextAlign.start,
            enabled: enabled,
            initialValue: hint != "Add Category" ? hint : null,
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
              if (finalVal.isEmpty || needsAtLeastOneCategory == true) {
                return 'Please finish adding a category ';
              }
            },
            onSaved: (String val) {
              if (hint != null) {
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
