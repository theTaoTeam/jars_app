import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/forms/add_jar.dart';

class AddJarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<AddJarPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int categoryCount = 0;
  final Map<String, dynamic> _formData = {
    'title': '',
    'categories': [],
    'image': null,
  };

  void addJar(MainModel model) {
    // First validate form.
    if (!this.formKey.currentState.validate()) {
      return;
    } else {
      formKey.currentState.save(); // Save our form now.
      print(_formData);
      model.addJar(_formData);
      Navigator.pop(context);
    }
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
    print('update category called: $val');
    setState(() {
      _formData['categories'].add(val);
    });
  }

  void updateImage(File image) {
    print('image: $image');
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
    final double height = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 25),
              icon: Icon(Icons.close),
              color: Theme.of(context).iconTheme.color,
              iconSize: Theme.of(context).iconTheme.size,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        body: Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 35,
                  ),
                  AddJarForm(
                    formKey: formKey,
                    updateCategory: updateCategory,
                    updateTitle: updateTitle,
                    updateImage: updateImage,
                    updateCategoryCount: updateCategoryCount,
                    categoryCount: categoryCount,
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(5),
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text('ADD',
                            style: TextStyle(
                                color: Theme.of(context).textTheme.title.color,
                                fontSize: 20,
                                letterSpacing: 3)),
                        onPressed: () {
                          addJar(model);
                        },
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
