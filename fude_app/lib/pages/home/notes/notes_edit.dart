import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/widgets/forms/edit_note_form_container.dart';
import 'package:fude/pages/home/notes/note.dart';
import 'package:fude/scoped-models/main.dart';
import 'dart:io';

class NoteEditPage extends StatefulWidget {
  final DocumentSnapshot note;

  NoteEditPage({this.note});

  @override
  State<StatefulWidget> createState() {
    return _AddNotePageState();
  }
}

class _AddNotePageState extends State<NoteEditPage> {
  String selectedCategory;
  String selectedJar;

  final Map<String, dynamic> _formData = {
    'category': '',
    'title': '',
    'link': '',
    'notes': '',
    'image': null,
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedCategory = widget.note['category'];
    });
  }

  void updateNote(MainModel model) {
    // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      print('adding to jar ${_formData['image']}');
      model.updateNote(widget.note, _formData['category'], _formData['title'],
          _formData['notes'], _formData['link'], _formData['image']);
      Navigator.pop(context);
    }
  }

  void updateCategory(dynamic value) {
    print("updating cateogory: $value");
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
              onPressed: () => Navigator.pushReplacement(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.upToDown,
                      child: NotePage(note: widget.note),
                    ),
                  ),
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
                    EditNoteForm(
                      formKey: formKey,
                      note: widget.note,
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
                            updateNote(model);
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
