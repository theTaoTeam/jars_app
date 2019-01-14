import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/helpers/recipes.dart';
import 'package:fude/models/recipe.dart';

mixin RecipeModel on Model {
  List<Recipe> _recipes;
  bool _isLoading = false;


  List<Recipe> get allRecipes {
    return _recipes;
  }

  Future<void> fetchRecipes() {
    _isLoading = true;
    notifyListeners();
    allRecipes;
    _isLoading = false;
    notifyListeners();
  }

}