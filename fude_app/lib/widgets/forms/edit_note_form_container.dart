import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/form-inputs/image.dart';
import 'package:fude/widgets/form-inputs/edit_note_input.dart';
import 'package:fude/scoped-models/main.dart';

class EditNoteForm extends StatelessWidget {
  final MainModel model;
  final DocumentSnapshot note;
  final GlobalKey formKey;
  final String selectedCategory;
  final Function updateCategory;
  final Function updateTitle;
  final Function updateLink;
  final Function updateNotes;
  final Function updateImage;

  EditNoteForm(
      {this.model,
      this.note,
      this.formKey,
      this.selectedCategory,
      this.updateCategory,
      this.updateTitle,
      this.updateLink,
      this.updateNotes,
      this.updateImage});

  @override
  Widget build(BuildContext context) {
    print(model.selectedJar['categories']);
    final List<dynamic> categoryList = model.selectedJar['categories'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: formKey,
          autovalidate: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropdownButton(
                    hint: Text(note.data['category'],
                        style: TextStyle(color: Colors.white)),
                    value: selectedCategory,
                    items: categoryList.map((val) {
                      return DropdownMenuItem(
                        value: val.toString(),
                        child: Text(val.toString()),
                      );
                    }).toList(),
                    onChanged: (dynamic val) {
                      print(val);
                      updateCategory(val);
                    },
                  ),
                ],
              ),
              EditNoteInput(
                initialVal: note.data['title'],
                hint: "Title",
                updateTitle: updateTitle,
              ),
              EditNoteInput(
                initialVal: note.data['link'],
                hint: "Link",
                updateLink: updateLink,
              ),
              EditNoteInput(
                initialVal: note.data['notes'],
                hint: 'Notes',
                updateNotes: updateNotes,
              ),
              ImageInput(updateImage: updateImage),
            ],
          )),
    );
  }
}
