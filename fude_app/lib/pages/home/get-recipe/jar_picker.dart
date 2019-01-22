import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fude/helpers/jars.dart';

class JarPicker extends StatelessWidget {
  final Function selectJar;
  final String selectedJar;

  final Color selectedColor = Colors.white;
  final Color notSelectedColor = Colors.black;
  final FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: 0);

  JarPicker({this.selectJar, this.selectedJar});

  List<Text> _buildPickerChildren() {
    List<Text> jarList = [];
    for (var i = 0; i <= jars.length - 1; i++) {
      jarList.add(Text(
        jars[i],
        style: TextStyle(
            color: selectedJar == jars[i] ? selectedColor : notSelectedColor),
      ));
    }
    return jarList;
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
          print('changed category to: ' + jars[newVal]);
          selectJar(newVal);
        },
        scrollController: scrollController,
      ),
    );
  }
}
