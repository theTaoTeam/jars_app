import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_recipe_form_container.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/recipes/allrecipes/all_recipes.dart';


class AddRecipePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddRecipePageState();
  }
}

class _AddRecipePageState extends State<AddRecipePage> {
  String selectedCategory;
  String selectedJar;

  final Map<String, dynamic> _formData = {
    'category': '',
    'jar': '',
    'title': '',
    'link': '',
    'notes': '',
    'image': AssetImage('assets/logo.png'),
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addRecipe(MainModel model) {
    model.addRecipe(_formData['category'], _formData['jar'], _formData['title'],
        _formData['notes'], _formData['link'], _formData['image']);
  }

  void updateCategory(dynamic value) {
    setState(() {
      selectedCategory = value;
      _formData['category'] = value;
    });
  }

  void updateJar(dynamic value) {
    setState(() {
      selectedJar = value;
      _formData['category'] = value;      
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
    setState(() {
      _formData['notes'] = value;
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
                        selectedJar: selectedJar,
                        updateJar: updateJar,
                        updateTitle: updateTitle,
                        updateLink: updateLink,
                        updateNotes: updateNotes,
                        updateImage: updateImage,
                      ),
                      model.isLoading
                          ? CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                print('add recipe tapped');
                                addRecipe(model);
                              },
                              child: Container(
                                width: 320.0,
                                height: 60.0,
                                margin: EdgeInsets.only(top: 20),
                                alignment: FractionalOffset.center,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(247, 64, 106, 1.0),
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(30.0)),
                                ),
                                child: Text(
                                  "add recipe",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
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
