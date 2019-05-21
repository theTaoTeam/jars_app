
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Jar {
  final String title;
  final List<dynamic> categories;
  final image;

  Jar({@required this.title, this.categories, this.image});
}
