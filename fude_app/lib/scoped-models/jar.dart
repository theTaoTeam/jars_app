import 'dart:async';

import 'package:flutter/services.dart';
import 'package:validators/validators.dart';
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
  List<QuerySnapshot> _allJarIdeas;
  final Map<String, dynamic> _addJar = {
    'owners': [],
    'title': 'ADD JAR',
    'categories': []
  };
  List<dynamic> _usersJars = [];

  bool _isLoading = false;

  bool darkTheme = false;

  DocumentSnapshot get selectedJar {
    return _selJar;
  }

  List<QuerySnapshot> get allJarIdeas {
    return _allJarIdeas;
  }

  bool get isLoading {
    return _isLoading;
  }

  List<dynamic> get usersJars {
    return _usersJars;
  }

  void addJar(Map<String, dynamic> data) async {
    print('in model.addJar: data: $data');
    _isLoading = true;
    notifyListeners();

    CollectionReference jarCollection = _firestore.collection('jars');
    String imageLocation;
    try {
      if (data['image'] != null) {
        imageLocation = await uploadNoteImageToStorage(data['image']);
      }
      final user = await _auth.currentUser();
      await jarCollection.document().setData(<String, dynamic>{
        'title': data['title'],
        'owners': FieldValue.arrayUnion([user.email]),
        'categories': data['categories'],
        'image': imageLocation == null
            ? 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604'
            : imageLocation.toString(),
        'isFav': false
      });
      fetchAllUserJars(user.email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void updateJar(Map<String, dynamic> data) async {
    print('updateJar Data: $data');
    String imageLocation;
    try {
      if (data['image'] != null) {
        imageLocation = await uploadNoteImageToStorage(data['image']);
      }
      if (data['categoriesToRemove'].length > 0) {
        await _firestore
            .collection('jars')
            .document(_selJar.documentID)
            .updateData({
          'categories': FieldValue.arrayRemove(data['categoriesToRemove']),
        });
      }
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .updateData({
        'categories': data['categoriesToAdd'].length > 0
            ? FieldValue.arrayUnion(data['categoriesToAdd'])
            : FieldValue.arrayUnion([]),
        'title': data['title'],
        'image':
            imageLocation == null ? _selJar['image'] : imageLocation.toString(),
        'isFav': _selJar['isFav']
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteJar() async {
    try {
      _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .delete()
          .catchError((err) => print(err));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void deleteJarIdea(String id) {
    try {
      _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document(id)
          .delete()
          .catchError((err) => print(err));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void getJarBySelectedId(String jarId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('jars').getDocuments().then((val) {
        val.documents.forEach((jar) {
          if (jar.documentID == jarId) {
            _selJar = jar;
          }
        });
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addToJar(String category, String title, String notes, String link,
      File image) async {
    print('image: ----------- $image');
    String imageLocation;
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

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadNoteImageToStorage(File image) async {
    final StorageReference ref =
        FirebaseStorage.instance.ref().child('images/');
    //Upload the file to firebase
    StorageUploadTask uploadTask = ref.putFile(image);
    // Waits till the file is uploaded then stores the download url
    String location;
    try {
      await uploadTask.onComplete.then((val) async {
        await val.ref.getDownloadURL().then((val) {
          // print('VAL $val, type: ${val.runtimeType}');
          location = val;
        });
      });
    } catch (e) {
      print(e);
    }
    // print('location: $location -------');
    //returns the download url
    return location;
  }

  void updateNote(DocumentSnapshot note, String category, String title,
      String notes, String link, File image) async {
    print('$category, $title, $notes, $link, $image');
    String imageLocation;
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
      notifyListeners();
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
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  addUserToJar(String email) async {
    FirebaseUser user;
    String returnMsg = 'user does not exist';
    _isLoading = true;
    notifyListeners();
    //run createUser function to see if email already exists. If it doesn't, delete the user and notify front end.
    try {
      user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: 'testuserpass');
      if (user.email == email) {
        print('created user because they did not exist yet');
        user.delete();

        _isLoading = false;
        notifyListeners();
        return returnMsg;
      }
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          try {
            await _firestore
                .collection('jars')
                .document(_selJar.documentID)
                .updateData({
              'owners': !_selJar.data['owners'].contains(email)
                  ? FieldValue.arrayUnion([email])
                  : FieldValue.arrayUnion([])
            });
          } catch (e) {
            print(e);
          }
          _isLoading = false;
          notifyListeners();
          returnMsg = 'user exists and has been added to jar!';
          return returnMsg;
        }
      }
    }
  }

  Future<List<dynamic>> fetchAllUserJars(String email) async {
    _isLoading = true;
    notifyListeners();
    _usersJars = [_addJar];
    QuerySnapshot jars;
    try {
      jars = await _firestore
          .collection('jars')
          .where('owners', arrayContains: email)
          .getDocuments();
      jars.documents.forEach((jar) {
        _usersJars.insert(1, jar);
      });
      // print('NEW LIST: $_usersJars');
    } catch (e) {
      print(e);
    }
    _isLoading = false;
    notifyListeners();
    return _usersJars;
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
          _jarNotesByCategory.add(doc);
        }
      });
    } else {
      return null;
    }
    return _jarNotesByCategory;
  }

  void launchURL(String url) async {
    if (isURL(url)) {
      print('is URL');
      if (!url.startsWith('https://') || !url.startsWith('http://')) {
        url = "https://$url";
      }
      if (await canLaunch(url)) {
        print('can launch this url!');
        await launch(url);
      } else {
        print('can launch this url!');
        throw 'Could not launch $url';
      }
    }
  }

  void invertTheme() {
    darkTheme = !darkTheme;
    notifyListeners();
  }

  numberOfIdeasInCategory(String category) async {
    int total = 0;
    QuerySnapshot ideas;
    try {
      ideas = await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .getDocuments();

      ideas.documents.forEach((idea) {
        if (idea.data['category'] == category) {
          total += 1;
        }
      });
    } catch (e) {
      print(e);
    }
    return total;
  }
}
