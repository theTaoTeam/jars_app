import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

mixin JarModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  DocumentSnapshot _selJar;

  bool _isLoading = false;

  DocumentSnapshot get selectedJar {
    return _selJar;
  }

  void addJar(String title, List<dynamic> categories) async {
    print('in model.addJar: title: $title');
    CollectionReference jarCollection = _firestore.collection('jars');
    try {
      final user = await _auth.currentUser();
      await jarCollection.document().setData(<String, dynamic>{
        'title': title,
        'owner': user.uid,
        'categories': categories,
      });
    } catch (e) {
      print(e);
    }
  }

  fetchJars() async {
    final user = await _auth.currentUser();
    List<String> jarList = [];
    QuerySnapshot jars;
    try {
      jars = await _firestore
          .collection('jars')
          .where('owner', isEqualTo: user.uid)
          .getDocuments();
      jars.documents.forEach((jar) => jarList.add(jar['title']));
    } catch (e) {
      print(e);
    }
    return jarList;
  }

  void getJarBySelectedId(String jarId) async {
    try {
      await _firestore.collection('jars').getDocuments().then((val) {
        val.documents.forEach((jar) {
          if (jar.documentID == jarId) {
            _selJar = jar;
            notifyListeners();
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }
}
