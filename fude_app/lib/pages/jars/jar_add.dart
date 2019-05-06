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
  bool imageSelected = false;
  bool needsAtLeastOneCategory = false;

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
      imageSelected = true;
      _formData['image'] = image;
    });
  }

  void updateCategoryCount() {
    print('categoryCount: $categoryCount');
    setState(() {
      if (imageSelected) {
        imageSelected = false;
      }
      categoryCount += 1;
      needsAtLeastOneCategory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    print('Building Jar_Add...');
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
                icon: Icon(Icons.keyboard_arrow_down),
                color: Theme.of(context).iconTheme.color,
                iconSize: Theme.of(context).iconTheme.size,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                })
          ],
        ),
        body: Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: ListView(
            // shrinkWrap: true,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * 0.04),
                  AddJarForm(
                      formKey: formKey,
                      imageSelected: imageSelected,
                      needsAtLeastOneCategory: needsAtLeastOneCategory,
                      updateCategory: updateCategory,
                      updateTitle: updateTitle,
                      updateImage: updateImage,
                      updateCategoryCount: updateCategoryCount,
                      categoryCount: categoryCount,
                      categories: _formData['categories'],
                      model: model),
                  SizedBox(height: height * 0.035),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.055,
                      ),
                      !model.isLoading
                          ? RaisedButton(
                              child: Text(
                                'ADD JAR',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  letterSpacing: 5,
                                ),
                              ),
                              elevation: 7,
                              highlightElevation: 1,
                              padding: EdgeInsets.all(15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Theme.of(context).secondaryHeaderColor,
                              splashColor: Colors.transparent,
                              highlightColor: Theme.of(context).primaryColor,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                addJar(model);
                              })
                          : CircularProgressIndicator(),
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
