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

  void addToJar(String category, String title, String notes, String link,
      AssetImage image) async {
    try {
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document()
          .setData(<String, dynamic>{
        'category': category,
        'title': title,
        'notes': notes,
        'link': link,
        'isFav': false,
      });
    } catch (e) {
      print(e);
    }
  }

  void toggleFavoriteStatus(DocumentSnapshot note) async {
    print('in toggle fav status');
    try {
      await _firestore
          .collection('favoriteNotes')
          .getDocuments()
          .then((snapshot) {
        if (snapshot.documents.length > 0) {
          snapshot.documents.forEach((doc) {
            if (doc.documentID == note.documentID) {
              print('found note in favnotes....deleting....');
              deleteFavNote(note.documentID);
            } else {
              print('no document with this note id in favnotes...adding....');
              addFavNote(note);
            }
          });
        } else {
          addFavNote(note);
        }
      }).catchError((err) => print(err));

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addFavNote(DocumentSnapshot note) async {
    try {
      //add note to favoriteNotes collections
      await _firestore
          .collection('favoriteNotes')
          .document()
          .setData(<String, dynamic>{
        'category': note['category'],
        'title': note['title'],
        'notes': note['notes'],
        'link': note['link'],
      });
      //update original note's isFav field
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document(note.documentID)
          .updateData({'isFav': !note.data['isFav']});
    } catch (e) {
      print(e);
    }
  }

  void deleteFavNote(String docID) async {
    try {
      await _firestore.collection('favoriteNotes').document(docID).delete();
    } catch (e) {
      print(e);
    }
  }
}
