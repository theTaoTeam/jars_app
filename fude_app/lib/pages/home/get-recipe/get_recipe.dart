import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/categories.dart';
import 'package:fude/helpers/jars.dart';
import 'package:fude/pages/home/get-recipe/category_picker.dart';
import 'package:fude/pages/home/get-recipe/jar_picker.dart';

class GetRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GetRecipePageState();
  }
}

class _GetRecipePageState extends State<GetRecipePage> {
  String selectedCategory = categories[0];
  String selectedJar = jars[0];

  void selectCategory(int newVal) {
    setState(() {
      selectedCategory = categories[newVal];
    });
  }

  void selectJar(int newVal) {
    setState(() {
      selectedJar = jars[newVal];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _targetWidth =
        deviceWidth > 550.0 ? 400.0 : deviceWidth * 0.65;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        padding: EdgeInsets.only(left: 5),
        width: _targetWidth,
        child: Row(
          
          children: <Widget>[
            Container(
              child: JarPicker(selectJar: selectJar, selectedJar: selectedJar),
            ),
            Container(
              child: CategoryPicker(
                  selectCategory: selectCategory,
                  selectedCategory: selectedCategory),
            )
          ],
        ),
        // height: MediaQuery.of(context).size.height / 3,
      );
    });
  }
}
