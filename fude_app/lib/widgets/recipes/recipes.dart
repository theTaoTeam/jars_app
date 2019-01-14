import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/models/recipe.dart';
import 'package:fude/widgets/recipes/recipe_card.dart';
import 'package:fude/helpers/recipes.dart';


class Recipes extends StatelessWidget {
  Widget _buildRecipeList(List<Recipe> recipes) {
    Widget recipeCards;
    if (recipes.length > 0) {
      recipeCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            RecipeCard(recipes[index], index),
        itemCount: recipes.length,
      );
    } else {
      recipeCards = Container();
    }
    return recipeCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return  _buildRecipeList(recipeCollection);
    },);
  }
}
