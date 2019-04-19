import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/forms/edit_jar.dart';

class EditJarPage extends StatefulWidget {
  final MainModel model;

  EditJarPage({this.model});
  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<EditJarPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int categoryCount = 0;
  bool needsAtLeastOneCategory = false;
  final Map<String, dynamic> _formData = {
    'title': '',
    'categories': [],
    'image': null,
  };

  @override
  void initState() {
    setState(() {
      widget.model.selectedJar['categories'].forEach((val) {
        _formData['categories'].add(val);
      });
    });
    super.initState();
  }

  void updateJar(MainModel model) {
    print('updating jar ${_formData['categories']}');
    //validate form.
    if (categoryCount > 0) {
      needsAtLeastOneCategory = false;
    }
    if (!this.formKey.currentState.validate() || needsAtLeastOneCategory) {
      return;
    } else {
      formKey.currentState.save();
      model.updateJar(_formData);
      Navigator.pop(context);
    }
  }

  void updateTitle(String val) {
    // print('update title called: $_formData');
    if (val != null) {
      _formData['title'] = val;
    }
  }

  void updateCategory(String val) {
    // print('category onSaved called: $val');
    if (val != '' && !_formData['categories'].contains(val)) {
      _formData['categories'].add(val);
    }
  }

  void updateImage(File image) {
    print('image: $image');
    setState(() {
      _formData['image'] = image;
    });
  }

  void updateCategoryCount(bool addCategory) {
    // print(categoryCount);
    addCategory
        ? setState(() {
            categoryCount += 1;
          })
        : setState(() {
            categoryCount -= 1;
          });
  }

  void removeCategory(String category) {
    print(_formData['categories']);
    if (_formData['categories'].length > 1) {
      setState(() {
        _formData['categories'].removeWhere((val) => val == category);
      });
      print(_formData['categories']);
    } else {
      setState(() {
        _formData['categories'].removeWhere((val) => val == category);
        needsAtLeastOneCategory = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
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
                  SizedBox(height: height * 0.04),
                  EditJarForm(
                    formKey: formKey,
                    model: model,
                    removeCategory: removeCategory,
                    jar: model.selectedJar,
                    categories: _formData['categories'],
                    needsAtLeastOneCategory: needsAtLeastOneCategory,
                    updateCategory: updateCategory,
                    updateTitle: updateTitle,
                    updateImage: updateImage,
                    updateCategoryCount: updateCategoryCount,
                    categoryCount: categoryCount,
                  ),
                  SizedBox(height: height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: width * 0.055,
                      ),
                      
                      RaisedButton(
                          child: Text(
                            'UPDATE JAR',
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          color: Theme.of(context).secondaryHeaderColor,
                          splashColor: Colors.transparent,
                          highlightColor: Theme.of(context).primaryColor,
                          onPressed: () => updateJar(model),
                        ),
                      
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
