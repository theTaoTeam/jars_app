import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String category;
  final String title;
  final String link;
  String notes;
  bool isFavorite;
  final AssetImage image;
  final DocumentReference reference;

  Recipe(
      {@required this.id,
      @required this.category,
      @required this.title,
      @required this.link,
      @required this.notes,
      this.isFavorite = false,
      this.image,
      this.reference});

  Recipe.fromMap(Map<String, dynamic> map, {this.reference})
     : assert(map['id'] != null),
        assert(map['title'] != null),
       assert(map['notes'] != null),
       assert(map['link'] != null),
       assert(map['category'] != null),
       assert(map['image'] != null),
       id = map['id'],
       title = map['title'],
       notes = map['notes'],
       link = map['link'],
       category = map['category'],
       image = map['image'];

  Recipe.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Recipe<$title:$category>";
}
