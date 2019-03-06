import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/helpers/categories.dart';
import 'package:fude/widgets/form-inputs/image.dart';
import 'package:fude/widgets/form-inputs/add_recipe_inputs.dart';

class AddRecipeForm extends StatelessWidget {
  final GlobalKey formKey;
  final String selectedCategory;
  final String selectedJar;
  final List<String> jarList;
  final Function updateCategory;
  final Function updateJar;
  final Function updateTitle;
  final Function updateLink;
  final Function updateNotes;
  final Function updateImage;

  AddRecipeForm(
      {this.formKey,
      this.jarList,
      this.selectedCategory,
      this.selectedJar,
      this.updateCategory,
      this.updateJar,
      this.updateTitle,
      this.updateLink,
      this.updateNotes,
      this.updateImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
              key: formKey,
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: DropdownButton(
                          hint: Text('category', style: TextStyle(color: Colors.white)),
                          value: selectedCategory,
                          items: categories.map((String val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (dynamic val) {
                            print(val);
                            updateCategory(val);
                          },
                        ),
                      ),
                      Container(
                        child: DropdownButton(
                          hint: Text('jar', style: TextStyle(color: Colors.white)),
                          value: selectedJar,
                          items: jarList.map((val) {
                            return DropdownMenuItem(
                              value: val,
                              child: Text(val),
                            );
                          }).toList(),
                          onChanged: (dynamic val) {
                            print(val);
                            updateJar(val);
                          },
                        ),
                      ),
                    ],
                  ),
                  AddRecipeInput(
                    hint: "Title",
                    updateTitle: updateTitle,
                  ),
                  AddRecipeInput(
                    hint: "Link",
                    updateLink: updateLink,
                  ),
                  AddRecipeInput(
                    hint: "Notes",
                    updateNotes: updateNotes,
                  ),
                  ImageInput(updateImage: updateImage),
                ],
              )),
        ],
      ),
    );
  }
}
