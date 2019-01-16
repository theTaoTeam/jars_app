import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/categories.dart';

class GetRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GetRecipeState();
  }
}

class _GetRecipeState extends State<GetRecipePage> {
  String isSelected = categories[0];
  Color selectedColor = Colors.white;
  Color notSelectedColor = Colors.black;
  final FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: 0);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
            image: AssetImage('assets/logo.png'),
          ),
        ),
        child: CupertinoPicker(
          children: <Widget>[
            Text(
              categories[0],
              style: TextStyle(
                  color: isSelected == categories[0]
                      ? selectedColor
                      : notSelectedColor),
            ),
            Text(
              categories[1],
              style: TextStyle(
                  color: isSelected == categories[1]
                      ? selectedColor
                      : notSelectedColor),
            ),
            Text(
              categories[2],
              style: TextStyle(
                  color: isSelected == categories[2]
                      ? selectedColor
                      : notSelectedColor),
            )
          ],
          diameterRatio: 1,
          useMagnifier: true,
          magnification: 2,
          backgroundColor: Colors.transparent,
          itemExtent: 30.0,
          onSelectedItemChanged: (int newVal) {
            print('changed category to: ' + categories[newVal]);
            setState(() {
              isSelected = categories[newVal];
            });
          },
          scrollController: scrollController,
        ),
      );
    });
  }
}
