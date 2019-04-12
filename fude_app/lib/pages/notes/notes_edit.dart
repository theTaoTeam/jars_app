import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/widgets/forms/edit_note_form_container.dart';
import 'package:fude/pages/notes/note.dart';
import 'package:fude/pages/jars/jar_notes.dart';
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
  bool nullCategory = false;

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
    if (!this.formKey.currentState.validate()) {
      return;
    } else {
      formKey.currentState.save(); // Save our form now.
      model.updateNote(widget.note, _formData['category'], _formData['title'],
          _formData['notes'], _formData['link'], _formData['image']);
      Navigator.pushReplacement(
        context,
        PageTransition(
          curve: Curves.linear,
          type: PageTransitionType.fade,
          child: JarNotes(model: model),
        ),
      );
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
              iconSize: Theme.of(context).iconTheme.size,
              onPressed: () => Navigator.pushReplacement(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.upToDown,
                      child: NotePage(
                        note: widget.note,
                        isRandom: false,
                      ),
                    ),
                  ),
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
                    EditNoteForm(
                      formKey: formKey,
                      note: widget.note,
                      categoryList: model.selectedJar.data['categories'],
                      nullCategory: nullCategory,
                      selectedCategory: selectedCategory,
                      updateCategory: updateCategory,
                      updateName: updateName,
                      updateLink: updateLink,
                      updateNotes: updateNotes,
                      updateImage: updateImage,
                    ),
                    SizedBox(height: height * 0.06),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: width * 0.057,
                        ),
                        GestureDetector(
                          onTap: () {
                            updateNote(model);
                          },
                          child: Container(
                            height: height * 0.05,
                            width: width * 0.45,
                            // padding: EdgeInsets.only(bottom: height * 0.1),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text('UPDATE IDEA',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.title.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    letterSpacing: 3,
                                  )),
                            ),
                          ),
                        ),
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
