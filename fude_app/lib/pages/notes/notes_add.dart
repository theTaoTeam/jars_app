import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:io';

import 'package:fude/widgets/forms/add_tojar_form_container.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar_notes.dart';

class AddNotePage extends StatefulWidget {
  final List<dynamic> categories;
  final bool fromJarScreen;
  final String category;

  AddNotePage({this.categories, this.fromJarScreen, this.category});

  @override
  State<StatefulWidget> createState() {
    return _AddNotePageState();
  }
}

class _AddNotePageState extends State<AddNotePage> {
  String selectedCategory;
  String selectedJar;
  bool nullCategory = false;
  MainModel model = MainModel();

  final Map<String, dynamic> _formData = {
    'category': '',
    'jar': '',
    'title': '',
    'link': null,
    'notes': '',
    'image': null,
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if(widget.category != null) {

    setState(() {
      selectedCategory = widget.category;
    });
    }
  }

  void addToJar(MainModel model) {
    // First validate form.
    if (_formData['category'] == '') {
      setState(() {
        nullCategory = true;
      });
      return;
    }
    if (!this.formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save(); // Save our form now.
    nullCategory = false;
    print(_formData);
    model.addToJar(_formData['category'], _formData['title'],
        _formData['notes'], _formData['link'], _formData['image']);
    FocusScope.of(context).requestFocus(FocusNode());
    widget.fromJarScreen
        ? Navigator.pop(context)
        : Navigator.pushReplacement(
            context,
            PageTransition(
              curve: Curves.linear,
              type: PageTransitionType.upToDown,
              child: JarNotes(model: model),
            ),
          );
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
    print('IMAGE: $image');
    setState(() {
      _formData['image'] = image;
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
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(Icons.keyboard_arrow_down),
              color: Theme.of(context).iconTheme.color,
              iconSize: 40,
              onPressed: () => widget.fromJarScreen
                  ? Navigator.pop(context)
                  : Navigator.pushReplacement(
                      context,
                      PageTransition(
                        curve: Curves.linear,
                        type: PageTransitionType.upToDown,
                        child: JarNotes(model: model),
                      ),
                    ),
            ),
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
                    AddToJarForm(
                      formKey: formKey,
                      categoryList: model.selectedJar.data['categories'],
                      category: widget.category,
                      selectedCategory: selectedCategory,
                      nullCategory: nullCategory,
                      updateCategory: updateCategory,
                      updateName: updateName,
                      updateLink: updateLink,
                      updateNotes: updateNotes,
                      updateImage: updateImage,
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
                            'ADD IDEA',
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
                          onPressed: () => addToJar(model),
                        ),
                        SizedBox(height: height * 0.05,)
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
