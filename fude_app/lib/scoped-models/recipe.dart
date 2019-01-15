import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/helpers/recipes.dart';
import 'package:fude/models/recipe.dart';

mixin RecipeModel on Model {
  List<Recipe> _recipes = recipeCollection;
  String _selRecipeId;

  bool _isLoading = false;

  List<Recipe> get allRecipes {
    return _recipes;
  }

  Recipe get selectedRecipe {
    if (selectedRecipeId == null) {
      return null;
    }

    return _recipes.firstWhere((Recipe recipe) {
      return recipe.id == _selRecipeId;
    });
  }

  int get selectedRecipeIndex {
    return _recipes.indexWhere((Recipe recipe) {
      return recipe.id == _selRecipeId;
    });
  }

  String get selectedRecipeId {
    return _selRecipeId;
  }

  void selectRecipe(String recipeId) {
    _selRecipeId = recipeId;
    // notifyListeners();
  }

  List<Recipe> fetchRecipes() {
    _isLoading = true;
    notifyListeners();
    final List<Recipe> fetchedProductList = recipeCollection;
    _isLoading = false;
    notifyListeners();
    return fetchedProductList;
  }

  void toggleRecipeFavoriteStatus() {
    final bool isFavorite = selectedRecipe.isFavorite;
    final bool newFavoriteStatus = !isFavorite;

    final Recipe updatedRecipe = Recipe(
      id: selectedRecipe.id,
      category: selectedRecipe.category,
      title: selectedRecipe.title,
      link: selectedRecipe.link,
      notes: selectedRecipe.notes,
      isFavorite: newFavoriteStatus,
    );
    _recipes[selectedRecipeIndex] = updatedRecipe;
    notifyListeners();
  }
}
