import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/recipes/recipe_card.dart';
import 'package:fude/models/recipe.dart';
import 'package:fude/scoped-models/main.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Recipe> recipes) {
    Widget productCards;
    if (recipes.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            RecipeCard(recipes[index], index),
        itemCount: recipes.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return  _buildProductList([Recipe(category: 'Lunch',title: 'test', link: 'test.com', description: 'testingtestingtesting') ]);
    },);
  }
}
