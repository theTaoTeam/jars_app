import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_recipe_form_container.dart';
import 'package:fude/pages/home/add-recipe/add_recipe_button.dart';
import 'package:fude/scoped-models/main.dart';

class AddRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddRecipePageState();
  }
}

class _AddRecipePageState extends State<AddRecipePage> {
  final Map<String, dynamic> _formData = {
    'title': '',
    'link': '',
    'description': '',
  };
  String selectedCategory;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void updateCategory(dynamic value) {
    setState(() {
      selectedCategory = value;
    });
  }

  void updateTitle(String value) {
    _formData['title'] = value;
  }

  void updateLink(String value) {
    _formData['link'] = value;
  }

  void updateDescription(String value) {
    _formData['description'] = value;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        child: Container(
          child: ListView(
            padding: EdgeInsets.only(top: deviceHeight * 0.10),
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AddRecipeForm(
                          formKey: formKey,
                          selectedCategory: selectedCategory,
                          updateCategory: updateCategory,
                          updateTitle: updateTitle,
                          updateLink: updateLink,
                          updateDescription: updateDescription),
                      model.isLoading ? CircularProgressIndicator() : AddRecipeButton(model: model),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
