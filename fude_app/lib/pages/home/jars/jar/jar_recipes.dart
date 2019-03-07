import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/recipe_card.dart';

class JarRecipes extends StatelessWidget {
  final DocumentSnapshot jar;

  JarRecipes({this.jar});

  _buildRecipeListItem(BuildContext context) {
    return Text('recipe list here');
    // return RecipeCard(recipe: document);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: _buildRecipeListItem(context)
    );
  }
}
