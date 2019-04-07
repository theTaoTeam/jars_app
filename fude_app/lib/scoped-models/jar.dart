import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

mixin JarModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  DocumentSnapshot _selJar;
  List<String> favoriteNotes;
  // List<DocumentSnapshot> _jarNotesByCategory = [];

  bool darkTheme = false;

  DocumentSnapshot get selectedJar {
    return _selJar;
  }

  void addJar(Map<String, dynamic> data) async {
    print('in model.addJar: data: $data');
    CollectionReference jarCollection = _firestore.collection('jars');
    Uri imageLocation;
    try {
      if (data['image'] != null) {
        imageLocation = await uploadNoteImageToStorage(data['image']);
      }
      final user = await _auth.currentUser();
      await jarCollection.document().setData(<String, dynamic>{
        'title': data['title'],
        'owner': user.uid,
        'categories': data['categories'],
        'image': imageLocation == null
            ? 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604'
            : imageLocation.toString(),
        'isFav': false
      });
    } catch (e) {
      print(e);
    }
  }

  void updateJar(Map<String, dynamic> data) async {
    print('$data');
    Uri imageLocation;
    try {
      if (data['image'] != null) {
        imageLocation = await uploadNoteImageToStorage(data['image']);
      }
      print(imageLocation);
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .updateData({
        'categories': data['categories'],
        'title': data['title'],
        'image':
            imageLocation == null ? _selJar['image'] : imageLocation.toString(),
        'isFav': _selJar['isFav']
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
        'image':
            imageLocation == null ? _selJar['image'] : imageLocation.toString(),
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
        'category': category == '' ? note['category'] : category,
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
      if (favoriteNotes != null) {
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

  Future<List<DocumentSnapshot>> fetchJarNotesByCategory(
      String category) async {
    List<DocumentSnapshot> _jarNotesByCategory = [];
    QuerySnapshot notes;
    try {
      notes = await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .getDocuments();
    } catch (e) {
      print(e);
    }
    if (notes.documents.length > 0) {
      notes.documents.forEach((doc) {
        if (doc.data['category'] == category) {
          // print(doc.documentID);
          _jarNotesByCategory.add(doc);
        }
      });
    } else {
      return null;
    }
    return _jarNotesByCategory;
  }

  void launchURL(String url) async {
    if (!url.startsWith('https://') || !url.startsWith('http://')) {
      url = "https://$url";
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void invertTheme() {
    darkTheme = !darkTheme;
    notifyListeners();
  }
}
