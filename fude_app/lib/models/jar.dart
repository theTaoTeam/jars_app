
import 'package:flutter/material.dart';
import 'package:fude/models/idea.dart';

class Jar {
  final String id;

  final String title;
  final List<dynamic> categories;
  final List<Idea> ideas;
  final image;

  Jar({@required this.title, this.id, this.categories, this.ideas, this.image});
}
