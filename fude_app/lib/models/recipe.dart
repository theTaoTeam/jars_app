import 'package:flutter/material.dart';

class Recipe {
  final String id;
  final String category;
  final String title;
  final String link;
  final String notes;
  final bool isFavorite;

  Recipe(
      {@required this.id,
      @required this.category,
      @required this.title,
      @required this.link,
      @required this.notes,
      this.isFavorite = false});
}
