import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:fude/models/recipe.dart';
import 'package:fude/scoped-models/main.dart';

class RecipeEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RecipeEditPageState();
  }
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'notes': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();

  Widget _buildImageField(Recipe recipe) {
    return FadeInImage(
      image: recipe.link != null
          ? NetworkImage(recipe.link)
          : AssetImage('assets/tempfudeicon.png'),
      height: 300.0,
      fit: BoxFit.cover,
      placeholder: AssetImage('assets/tempfudeicon.png'),
    );
  }

  Widget _buildTitleTextField(Recipe recipe) {
    return TextFormField(
      focusNode: _titleFocusNode,
      decoration: InputDecoration(labelText: 'Recipe Title'),
      initialValue: recipe == null ? '' : recipe.title,
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildNotesTextField(Recipe recipe) {
    return TextFormField(
      focusNode: _notesFocusNode,
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Recipe notes'),
      initialValue: recipe == null ? '' : recipe.notes,
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty || value.length < 10) {
          return 'notes is required and should be 10+ characters long.';
        }
      },
      onSaved: (String value) {
        _formData['notes'] = value;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(child: CircularProgressIndicator())
          : RaisedButton(
              child: Text('Save'),
              textColor: Colors.white,
              onPressed: () {
                print("Submit Button presses");
              },
              // _submitForm(
              // model.addRecipe,
              // model.updateRecipe,
              // model.selectRecipe,
              // model.selectedRecipeIndex),
            );
    });
  }

  Widget _buildPageContent(BuildContext context, Recipe recipe) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildImageField(recipe),
              _buildTitleTextField(recipe),
              _buildNotesTextField(recipe),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My Button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(
        _formData['title'],
        _formData['notes'],
        _formData['image'],
        _formData['price'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try again!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateProduct(
        _formData['title'],
        _formData['notes'],
        _formData['image'],
        _formData['price'],
      ).then((_) => Navigator.pushReplacementNamed(context, '/products')
          .then((_) => setSelectedProduct(null)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedRecipe);
        return model.selectedRecipeIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Recipe'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
