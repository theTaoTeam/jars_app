import 'package:flutter/material.dart';

import 'package:fude/widgets/form-inputs/image.dart';
import 'package:fude/widgets/form-inputs/add_recipe_inputs.dart';

class AddToJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final String selectedCategory;
  final List<dynamic> categoryList;
  final Function updateCategory;
  final Function updateTitle;
  final Function updateLink;
  final Function updateNotes;
  final Function updateImage;

  AddToJarForm(
      {this.formKey,
      this.categoryList,
      this.selectedCategory,
      this.updateCategory,
      this.updateTitle,
      this.updateLink,
      this.updateNotes,
      this.updateImage});

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
    );
  }
}
