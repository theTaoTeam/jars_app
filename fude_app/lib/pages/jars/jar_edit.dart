import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:io';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/forms/edit_jar.dart';
import 'package:fude/widgets/forms/add_user_to_jar.dart';

class EditJarPage extends StatefulWidget {
  final MainModel model;
  final DocumentSnapshot jar;

  EditJarPage({this.model, this.jar});
  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<EditJarPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addUserFormKey = GlobalKey<FormState>();
  int categoryCount = 0;
  bool needsAtLeastOneCategory = false;
  List<dynamic> currentCategories = [];
  bool userHasBeenAdded = false;
  bool needToInviteThisUser = false;
  bool loadingJarData = true;
  final Map<String, dynamic> _formData = {
    'title': '',
    'categoriesToAdd': [],
    'categoriesToRemove': [],
    'image': null,
  };
  String userToAdd;

  @override
  void initState() {
    _waitingForJarData();
    widget.model.getJarBySelectedId(widget.jar.documentID);
    widget.model.resetIsLoading();
    super.initState();
  }

  void updateJar(MainModel model) {
    //validate form.
    if (!this.formKey.currentState.validate() || needsAtLeastOneCategory) {
      return;
    } else {
      formKey.currentState.save();
      model.updateJar(_formData);
      Navigator.pop(context);
    }
  }

  void updateTitle(String val) {
    if (val != null) {
      _formData['title'] = val;
    }
  }

  void updateCategory(String val) {
    print(val);
    if (val != '' && !_formData['categoriesToAdd'].contains(val)) {
      _formData['categoriesToAdd'].add(val);
    }
  }

  void updateImage(File image) {
    print('image: $image');
    setState(() {
      _formData['image'] = image;
    });
  }

  void updateCategoryCount() {
    setState(() {
      categoryCount += 1;
      needsAtLeastOneCategory = false;
    });
  }

  void addCategoryToRemoveList(String category) {
    _formData['categoriesToRemove'].add(category);
    setState(() {
      if (currentCategories.length == 1 && categoryCount == 0) {
        needsAtLeastOneCategory = true;
      }
      currentCategories.removeWhere((val) => val == category);
    });
  }

  void addUserToJar(String email) {
    setState(() {
      userToAdd = email;
    });
  }

  void userHasBeenAddedStateUpdate() {
    setState(() {
      userHasBeenAdded = true;
    });
    Timer(Duration(seconds: 2), () {
      setState(() {
        userHasBeenAdded = false;
      });
    });
  }

  void needToInviteThisUserStateUpdate() {
    setState(() {
      needToInviteThisUser = true;
    });
    Timer(Duration(seconds: 6), () {
      setState(() {
        needToInviteThisUser = false;
      });
    });
  }

  void submitAddUser() {
    if (!this.addUserFormKey.currentState.validate()) {
      return;
    } else {
      addUserFormKey.currentState.save();
      widget.model.addUserToJar(userToAdd).then((val) {
        if (val == 'user exists and has been added to jar!') {
          userHasBeenAddedStateUpdate();
        } else {
          needToInviteThisUserStateUpdate();
        }
      });
    }
  }

  void _waitingForJarData() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        currentCategories =
            widget.model.selectedJar.data['categories'].toList();
        loadingJarData = false;
      });
    });
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
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.pop(context);
                }),
          ],
        ),
        body: Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: !loadingJarData
              ? ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * 0.04),
                        EditJarForm(
                          formKey: formKey,
                          model: model,
                          jar: model.selectedJar,
                          addCategoryToRemoveList: addCategoryToRemoveList,
                          categories: currentCategories,
                          needsAtLeastOneCategory: needsAtLeastOneCategory,
                          updateCategory: updateCategory,
                          updateTitle: updateTitle,
                          updateImage: updateImage,
                          updateCategoryCount: updateCategoryCount,
                          categoryCount: categoryCount,
                        ),
                        AddUserToJarForm(
                            addUserFormKey: addUserFormKey,
                            addUserToJar: addUserToJar,
                            submitAddUser: submitAddUser,
                            userHasBeenAdded: userHasBeenAdded,
                            needToInviteThisUser: needToInviteThisUser,
                            model: model),
                        SizedBox(height: height * 0.04),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                              width * 0.045, 0, width * 0.045, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  color: Theme.of(context).secondaryHeaderColor,
                                  splashColor: Colors.transparent,
                                  highlightColor:
                                      Theme.of(context).primaryColor,
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    updateJar(model);
                                  }),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  iconSize: 36,
                                  color: Colors.red,
                                  onPressed: () {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    model.deleteJar();
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                  ),
                ),
        ),
      );
    });
  }
}
