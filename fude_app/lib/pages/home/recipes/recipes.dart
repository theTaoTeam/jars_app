import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/pages/home/recipes/recipe_card.dart';

class Recipes extends StatelessWidget {

  _buildRecipeListItem(BuildContext context, DocumentSnapshot document) {
    return RecipeCard(recipe: document);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('snapshot hasData: ${snapshot.hasData}');
            return Center(child: CircularProgressIndicator());
          } else {
            print('returning listview.builder...');
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
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
