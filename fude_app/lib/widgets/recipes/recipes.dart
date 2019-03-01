import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/recipes/recipe_card.dart';

class Recipes extends StatelessWidget {

  _buildRecipeListItem(BuildContext context, DocumentSnapshot document) {
    return RecipeCard(document);
  }

  @override
  Widget build(BuildContext context) {
    // print(Firestore.instance.collection('recipes').document());
    return StreamBuilder(
        stream: Firestore.instance.collection('recipes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            print('snapshot has no data: ${snapshot.hasData}');
            return Text('Loading...');
          } else {
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
