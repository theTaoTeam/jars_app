import 'package:flutter/material.dart';

import 'package:fude/widgets/form-inputs/add_jar_name_input.dart';
import 'package:fude/widgets/form-inputs/add_jar_category_input.dart';

class AddJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final int categoryCount;
  final Function updateTitle;
  final Function updateCategory;
  final Function incrementCategoryCount;

  AddJarForm(
      {this.formKey,
      this.categoryCount,
      this.updateTitle,
      this.updateCategory,
      this.incrementCategoryCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: formKey,
          autovalidate: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AddJarNameField(
                hint: "Jar Name",
                updateTitle: updateTitle,
              ),
              SizedBox(height: 20,),
              AddJarCategoryField(
                hint: 'Category',
                updateCategory: updateCategory,
              ),
              AddJarCategoryField(
                hint: 'Category',
                updateCategory: updateCategory,
              ),
              AddJarCategoryField(
                hint: 'Category',
                updateCategory: updateCategory,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        incrementCategoryCount();
                      }),
                  Text('add another category'),
                ],
              )
            ],
          )),
    );
  }
}
