import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

mixin JarModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  DocumentSnapshot _selJar;
  List<String> favoriteNotes;

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
      File image) async {
    print('image: ----------- $image');
    Uri imageLocation;
    try {
      if (image != null) {
        imageLocation = await uploadNoteImageToStorage(image);
      }
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
        'image': imageLocation.toString(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Uri> uploadNoteImageToStorage(File image) async {
    final StorageReference ref =
        FirebaseStorage.instance.ref().child('images/');
    //Upload the file to firebase
    StorageUploadTask uploadTask = ref.putFile(image);
    // Waits till the file is uploaded then stores the download url
    Uri location = (await uploadTask.future).downloadUrl;
    //returns the download url
    print(location);
    return location;
  }

  void updateNote(DocumentSnapshot note, String category, String title,
      String notes, String link, File image) async {
    print('$category, $title, $notes, $link, $image');
    Uri imageLocation;
    try {
      if (image != null) {
        imageLocation = await uploadNoteImageToStorage(image);
      }
      print(imageLocation);
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document(note.documentID)
          .updateData({
        'category': category,
        'title': title,
        'notes': notes,
        'link': link,
        'isFav': note['isFav'],
        'image':
            imageLocation == null ? note['image'] : imageLocation.toString()
      });
    } catch (e) {
      print(e);
    }
  }

  void toggleFavoriteStatus(DocumentSnapshot note) async {
    print('in toggle fav status');
    try {
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document(note.documentID)
          .updateData({'isFav': !note.data['isFav']});
      if (favoriteNotes.length > 0) {
        favoriteNotes.forEach((id) {
          if (id == note.documentID) {
            favoriteNotes.remove(id);
          } else {
            favoriteNotes.add(note.documentID);
          }
        });
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
