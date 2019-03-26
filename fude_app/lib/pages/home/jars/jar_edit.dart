import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/forms/edit_jar.dart';

class EditJarPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<EditJarPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int categoryCount = 0;
  final Map<String, dynamic> _formData = {
    'title': '',
    'categories': [],
    'image': null,
  };

  void updateJar(MainModel model) {
    // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      print('form saved.....sending to model');
    }
    // model.updateJar(_formData['title'], _formData['category']);
    Navigator.pop(context);
  }

  void updateTitle(String val) {
    print('update title called: $_formData');
    if (val != null) {
      setState(() {
        _formData['title'] = val;
      });
    }
  }

  void updateCategory(String val) {
    print('update category called: $_formData');
    setState(() {
      _formData['categories'].add(val);
    });
  }

  void updateImage(File image) {
    print(image);
    setState(() {
      _formData['image'] = image;
    });
  }

  void updateCategoryCount() {
    print(categoryCount);
    setState(() {
      categoryCount += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Color.fromRGBO(33, 38, 43, 1),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 25),
              icon: Icon(Icons.close),
              color: Color.fromRGBO(236, 240, 241, 1),
              iconSize: 34,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(33, 38, 43, 1),
            ),
            child: ListView(
              // shrinkWrap: true,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 35,
                    ),
                    EditJarForm(
                      formKey: formKey,
                      jar: model.selectedJar,
                      updateCategory: updateCategory,
                      updateTitle: updateTitle,
                      categoryCount: categoryCount,
                      updateCategoryCount: updateCategoryCount,
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text('UPDATE JAR'),
                          onPressed: () {},
                        )
                      ],
                    )
                  ],
                ),
              ],
            )),
      );
    });
  }
}
