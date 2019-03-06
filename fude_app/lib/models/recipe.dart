import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String category;
  final String jar;
  final String title;
  final String link;
  String notes;
  bool isFavorite;
  final AssetImage image;
  final DocumentReference reference;

  Recipe(
      {@required this.id,
      @required this.category,
      @required this.jar,
      @required this.title,
      @required this.link,
      @required this.notes,
      this.isFavorite = false,
      this.image,
      this.reference});

}
