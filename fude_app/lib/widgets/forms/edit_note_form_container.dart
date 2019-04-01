import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/form-inputs/image.dart';
import 'package:fude/widgets/form-inputs/edit_note_input.dart';

class EditNoteForm extends StatelessWidget {
  final GlobalKey formKey;
  final DocumentSnapshot note;
  final String selectedCategory;
  final List<dynamic> categoryList;
  final Function updateCategory;
  final Function updateName;
  final Function updateLink;
  final Function updateNotes;
  final Function updateImage;

  EditNoteForm(
      {this.formKey,
      this.note,
      this.categoryList,
      this.selectedCategory,
      this.updateCategory,
      this.updateName,
      this.updateLink,
      this.updateNotes,
      this.updateImage});

  Widget _buildTextSections(String hint, String val) {
    Function update;
    if (hint == "Name") {
      update = updateName;
    } else if (hint == "Link") {
      update = updateLink;
    } else if (hint == 'Notes') {
      update = updateNotes;
    }
    return EditNoteInput(
      hint: hint,
      initialVal: val,
      update: update,
    );
  }

  @override
  Widget build(BuildContext context) {
    print(categoryList);
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
                    hint:
                        Text('category', style: TextStyle(color: Colors.white)),
                    value: selectedCategory,
                    style: TextStyle(color: Colors.white),
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
              SizedBox(height: 40),
              _buildTextSections('Name', note['title']),
              SizedBox(height: 30),
              _buildTextSections('Link', note['link']),
              SizedBox(height: 30),
              _buildTextSections('Notes', note['notes']),
              SizedBox(height: 40),
              ImageInput(updateImage: updateImage),
            ],
          )),
    );
  }
}
