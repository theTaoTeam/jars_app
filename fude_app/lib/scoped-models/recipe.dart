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

  // List<Recipe> _recipes = recipeCollection;
  String _selRecipeId;

  // List<Recipe> get allRecipes {
  //   return _recipes;
  // }

  // Recipe get selectedRecipe {
  //   if (selectedRecipeId == null) {
  //     return null;
  //   }

  //   return _recipes.firstWhere((Recipe recipe) {
  //     return recipe.id == _selRecipeId;
  //   });
  // }

  // int get selectedRecipeIndex {
  //   return _recipes.indexWhere((Recipe recipe) {
  //     return recipe.id == _selRecipeId;
  //   });
  // }

  // String get selectedRecipeId {
  //   return _selRecipeId;
  // }

  // void selectRecipe(String recipeId) {
  //   _selRecipeId = recipeId;
  //   // notifyListeners();
  // }

  void addRecipe(String category, String jar, String title, String notes,
      String link, AssetImage image) async {
    CollectionReference recipeCollection = _firestore.collection('recipes');
    try {
      final user = await _auth.currentUser();
      // print(_firestore.collection);
      await recipeCollection.add(<String, dynamic>{
        category: category,
        jar: jar,
        title: title,
        notes: notes,
        link: link,
      });
    } catch (e) {
      print(e);
    }
  }

  // List<Recipe> fetchRecipes() {
  //   _isLoading = true;
  //   notifyListeners();
  //   final List<Recipe> fetchedProductList = recipeCollection;
  //   _isLoading = false;
  //   notifyListeners();
  //   return fetchedProductList;
  // }

//   Future<bool> updateFavorites(String uid, String recipeId) {
//   DocumentReference favoritesReference =
//       Firestore.instance.collection('users').document(uid);

//   return Firestore.instance.runTransaction((Transaction tx) async {
//     DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
//     if (postSnapshot.exists) {
//       // Extend 'favorites' if the list does not contain the recipe ID:
//       if (!postSnapshot.data['favorites'].contains(recipeId)) {
//         await tx.update(favoritesReference, <String, dynamic>{
//           'favorites': FieldValue.arrayUnion([recipeId])
//         });
//       // Delete the recipe ID from 'favorites':
//       } else {
//         await tx.update(favoritesReference, <String, dynamic>{
//           'favorites': FieldValue.arrayRemove([recipeId])
//         });
//       }
//     } else {
//       // Create a document for the current user in collection 'users'
//       // and add a new array 'favorites' to the document:
//       await tx.set(favoritesReference, {
//         'favorites': [recipeId]
//       });
//     }
//   }).then((result) {
//     return true;
//   }).catchError((error) {
//     print('Error: $error');
//     return false;
//   });
// }

// Future<List<String>> getFavorites(String uid) async {
//     DocumentSnapshot querySnapshot = await Firestore.instance
//         .collection('users')
//         .document(uid)
//         .get();
//     if (querySnapshot.exists &&
//         querySnapshot.data.containsKey('favorites') &&
//         querySnapshot.data['favorites'] is List) {
//       // Create a new List<String> from List<dynamic>
//       return List<String>.from(querySnapshot.data['favorites']);
//     }
//     return [];
//   }

//   void addRecipe(String title, String link, String notes, String category,
//       String jar) async {
//     final Recipe newRecipe = Recipe(
//         title: title, link: link, notes: notes, category: category);
//     await _firestore
//         .collection('recipes')
//         .document()
//         .setData({newRecipe});
//   }
}
