import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/models/recipe.dart';
import 'package:fude/widgets/recipes/recipe_card.dart';
import 'package:fude/pages/recipes/allrecipes/recipe_edit.dart';

class Recipes extends StatelessWidget {
  // Widget _buildRecipeList(List<Recipe> recipes) {
  //   Widget recipeCards;
  //   if (recipes.length > 0) {
  //     recipeCards = ListView.builder(
  //       itemBuilder: (BuildContext context, int index) =>
  //           RecipeCard(recipes[index], index),
  //       itemCount: recipes.length,
  //     );
  //   } else {
  //     recipeCards = Container();
  //   }
  //   return recipeCards;
  // }

  _buildRecipeListItem(BuildContext context, DocumentSnapshot document) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(document['title']),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(10.0),
            child: Text(document['link']),
          )
        ],
      ),
      onTap: () => print('recipe tapped'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(Firestore.instance.collection('recipes').document());
    return StreamBuilder(
        stream: Firestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('snapshot has no data');
            return Text('Loading...');
          } else {
              print(snapshot.data.documents[0]['title']);
            return ListView.builder(
              // shrinkWrap: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildRecipeListItem(
                    context, snapshot.data.documents[index]);
              },
            );
          }
        });
  }
}
