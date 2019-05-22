import 'package:flutter/material.dart';

class Idea {
  final String id;
  final String category;
  final String title;
  final String link;
  final String notes;
  bool isFav;
  final image;

  bool get getIsFav => isFav;
  set setIsFav(bool newBool) {
    isFav = newBool;
  }

  Idea(
      {@required this.title,
      this.id,
      this.link,
      this.category,
      this.notes,
      this.isFav,
      this.image});
}
