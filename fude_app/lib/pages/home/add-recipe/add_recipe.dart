import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_recipe_form_container.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/background_image.dart';
import 'package:fude/pages/home/add-recipe/add_recipe_button.dart';
import 'package:fude/pages/recipes/allrecipes/all_recipes.dart';

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
    'image': AssetImage('assets/logo.png'),
  };
  String selectedCategory;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void updateCategory(dynamic value) {
    setState(() {
      selectedCategory = value;
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

  void updateDescription(String value) {
    setState(() {
      _formData['description'] = value;
    });
  }

  void updateImage(Image image) {
    setState(() {
      _formData['image'] = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        decoration:
            BoxDecoration(image: buildBackgroundImage(_formData['image'])),
        child: Container(
          child: ListView(
            padding: EdgeInsets.only(top: deviceHeight * 0.05),
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
                        updateDescription: updateDescription,
                        updateImage: updateImage,
                      ),
                      model.isLoading
                          ? CircularProgressIndicator()
                          : AddRecipeButton(model: model),
                      Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.keyboard_arrow_up,
                                  color: Colors.white),
                              GestureDetector(
                                child: Text('swipe up to see all recipes',
                                    style: TextStyle(color: Colors.white)),
                                onVerticalDragStart:
                                    (DragStartDetails details) {
                                  print('swiped up' + details.toString());
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) {
                                        return AllRecipesPage(model);
                                      },
                                      transitionsBuilder: (context, animation1,
                                          animation2, child) {
                                        return FadeTransition(
                                          opacity: animation1,
                                          child: child,
                                        );
                                      },
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ))
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
