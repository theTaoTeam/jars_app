import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/pages/home/main_view.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/side_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(175, 31, 82, 1),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          onPressed: () => Navigator.pushNamed(context, '/addjar'),
        ),
        drawer: buildSideDrawer(context, model),
        body: Container(child: MainView(model: model)),
      );
    });
  }
}
