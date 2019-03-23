import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/design_helpers.dart';
import 'package:fude/widgets/side_drawer.dart';
import 'package:fude/pages/home/jars/fav_tab.dart';
import 'package:fude/pages/home/jars/all_notes_tab.dart';
import 'package:fude/pages/home/notes/notes_add.dart';

class JarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.9), BlendMode.dstATop),
                  image: model.selectedJar.data['image'] != null
                      ? NetworkImage(model.selectedJar.data['image'])
                      : logoInStorage()),
            ),
            child: Center(
              child: Text(
                model.selectedJar.data['title'],
                style: TextStyle(color: Colors.white),
              ),
            )),
      );
    });
  }
}
