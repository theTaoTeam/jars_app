import 'package:flutter/material.dart';

import 'package:fude/helpers/categories.dart';
import './add_recipe_inputs.dart';

class AddRecipeForm extends StatelessWidget {
  final GlobalKey formKey;
  final String selectedCategory;
  final Function updateCategory;
  final Function updateTitle;
  final Function updateLink;
  final Function updateDescription;

  AddRecipeForm({
    this.formKey,
    this.selectedCategory,
    this.updateCategory,
    this.updateTitle,
    this.updateLink,
    this.updateDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 230),
                    child: DropdownButton(
                      hint: Text('category'),
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
                  AddRecipeInput(
                    hint: "Title",
                    updateTitle: updateTitle,
                  ),
                  AddRecipeInput(
                    hint: "Link",
                    updateLink: updateLink,
                  ),
                  AddRecipeInput(
                    hint: "Description",
                    updateDescription: updateDescription,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
