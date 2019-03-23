import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:fude/widgets/forms/edit_note_form_container.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/side_drawer.dart';
import 'package:fude/helpers/design_helpers.dart';

class NotesEditPage extends StatefulWidget {
  final DocumentSnapshot note;
  final MainModel model;

  NotesEditPage({this.note, this.model});

  @override
  State<StatefulWidget> createState() {
    return _NotesEditPageState();
  }
}

class _NotesEditPageState extends State<NotesEditPage> {
  final Map<String, dynamic> _formData = {
    'title': '',
    'notes': '',
    'category': '',
    'link': '',
    'image': null
  };
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedCategory;
  String selectedJar;

  void updateCategory(dynamic value) {
    setState(() {
      selectedCategory = value;
      _formData['category'] = value.toString();
    });
  }

  void updateTitle(String value) {
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
    print('updating notes');
    setState(() {
      _formData['notes'] = value;
    });
  }

  void updateImage(File image) {
    print('updating image');
    setState(() {
      _formData['image'] = image;
    });
  }

  void updateNote() {
     // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      widget.model.updateNote(
          widget.note,
          _formData['category'],
          _formData['title'],
          _formData['notes'],
          _formData['link'],
          _formData['image']);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(175, 31, 82, 1),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      drawer: buildSideDrawer(context, widget.model),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.red,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: deviceHeight * 0.10),
        width: deviceWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Color.fromRGBO(0, 0, 0, 0.7), BlendMode.dstATop),
            image: widget.note['image'] != ''
                ? NetworkImage(widget.note['image'])
                : logoInStorage(),
          ),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            EditNoteForm(
              model: widget.model,
              note: widget.note,
              formKey: formKey,
              updateCategory: updateCategory,
              updateImage: updateImage,
              updateLink: updateLink,
              updateNotes: updateNotes,
              updateTitle: updateTitle,
            ),
            widget.model.isLoading
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: () {
                      print('save tapped');
                      updateNote();
                    },
                    child: Container(
                      width: 320.0,
                      height: 60.0,
                      margin: EdgeInsets.only(top: 10),
                      alignment: FractionalOffset.center,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(247, 64, 106, 1.0),
                        borderRadius:
                            BorderRadius.all(const Radius.circular(30.0)),
                      ),
                      child: Text(
                        "save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
