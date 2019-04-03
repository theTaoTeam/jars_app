import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_tojar_form_container.dart';
import 'package:fude/scoped-models/main.dart';
import 'dart:io';

class AddNotePage extends StatefulWidget {
  final List<dynamic> categories;

  AddNotePage({this.categories});

  @override
  State<StatefulWidget> createState() {
    return _AddNotePageState();
  }
}

class _AddNotePageState extends State<AddNotePage> {
  String selectedCategory;
  String selectedJar;
  MainModel model = MainModel();

  final Map<String, dynamic> _formData = {
    'category': '',
    'jar': '',
    'title': '',
    'link': '',
    'notes': '',
    'image': null,
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void addToJar(MainModel model) {
    // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      print('adding to jar ${_formData['image']}');
      model.addToJar(_formData['category'], _formData['title'],
          _formData['notes'], _formData['link'], _formData['image']);
      Navigator.pop(context);
    }
  }

  void updateCategory(dynamic value) {
    setState(() {
      selectedCategory = value;
      _formData['category'] = value.toString();
    });
  }

  void updateName(String value) {
    setState(() {
      _formData['title'] = value;
    });
  }

  void updateLink(String value) {
    setState(() {
      _formData['link'] = value;
    });
  }

  void updateNotes(String value) {
    setState(() {
      _formData['notes'] = value;
    });
  }

  void updateImage(File image) {
    print(image);
    setState(() {
      _formData['image'] = image;
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
          backgroundColor: Color.fromRGBO(33, 38, 43, 1),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 25),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(Icons.close),
              color: Color.fromRGBO(236, 240, 241, 1),
              iconSize: 34,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        body: Container(
            height: height,
            decoration: BoxDecoration(
              color: Color.fromRGBO(33, 38, 43, 1),
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
                    AddToJarForm(
                      formKey: formKey,
                      categoryList: model.selectedJar.data['categories'],
                      selectedCategory: selectedCategory,
                      updateCategory: updateCategory,
                      updateName: updateName,
                      updateLink: updateLink,
                      updateNotes: updateNotes,
                      updateImage: updateImage,
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
                          child: Text('ADD TO JAR'),
                          onPressed: () {
                            addToJar(model);
                          },
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
