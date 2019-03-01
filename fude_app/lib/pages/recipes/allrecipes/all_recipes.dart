import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/scoped-models/main.dart';

import 'package:fude/widgets/recipes/recipes.dart';

class AllRecipesPage extends StatefulWidget {
  final MainModel model;

  AllRecipesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AllRecipesPageState();
  }
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  @override
  initState() {
    // widget.model.fetchRecipes();
    super.initState();
  }

  Widget _buildRecipeList(MainModel model) {
    Widget content = Center(child: Text('No Products Found!'));
    if (!model.isLoading) {
      if (!model.isLoading) {
        content = Recipes();
      } else if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      }
      return content;
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('All Recipes'),
        ),
        body: _buildRecipeList(model),
      );
    });
  }
}
