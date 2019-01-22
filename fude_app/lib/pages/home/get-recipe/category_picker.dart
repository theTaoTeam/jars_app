import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fude/helpers/categories.dart';

class CategoryPicker extends StatelessWidget {
  final Function selectCategory;
  final String selectedCategory;

  final Color selectedColor = Colors.white;
  final Color notSelectedColor = Colors.black;
  final FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: 0);

  CategoryPicker({this.selectCategory, this.selectedCategory});

  List<Text> _buildPickerChildren() {
    List<Text> categoryList = [];
    for (var i = 0; i <= categories.length - 1; i++) {
      categoryList.add(Text(
        categories[i],
        style: TextStyle(
            color: selectedCategory == categories[i]
                ? selectedColor
                : notSelectedColor),
      ));
    }
    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: CupertinoPicker(
        children: _buildPickerChildren(),
        diameterRatio: 1,
        backgroundColor: Colors.transparent,
        itemExtent: 30.0,
        offAxisFraction: 0,
        onSelectedItemChanged: (int newVal) {
          print('changed category to: ' + categories[newVal]);
          selectCategory(newVal);
        },
        scrollController: scrollController,
      ),
    );
  }
}
