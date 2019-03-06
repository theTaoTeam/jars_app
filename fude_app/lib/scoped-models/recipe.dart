import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:fude/helpers/recipes.dart';
import 'package:fude/models/recipe.dart';

mixin RecipeModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  bool _isLoading = false;
  String _selRecipeId;

  void addRecipe(String category, String jar, String title, String notes,
      String link, AssetImage image) async {
    CollectionReference recipeCollection = _firestore.collection('recipes');
    try {
      final user = await _auth.currentUser();
      // print(recipeCollection.document().setData({}));
      
      await recipeCollection.document().setData(<String, dynamic>{
        'category': category,
        'jar': jar,
        'title': title,
        'notes': notes,
        'link': link,
        'owner': user.uid,
      });
    } catch (e) {
      print(e);
    }
  }

  
}
