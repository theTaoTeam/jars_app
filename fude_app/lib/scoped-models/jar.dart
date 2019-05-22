import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validators/validators.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fude/models/jar.dart';
import 'package:fude/models/idea.dart';
import 'package:uuid/uuid.dart';

mixin JarModel on Model {
  bool _isLoading = false;
  bool _darkTheme = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  DocumentSnapshot _selJar;
  List<QuerySnapshot> _allJarIdeas;
  final Jar _addJar = Jar(title: 'ADD JAR', categories: [], image: null);

  List<dynamic> _usersJars = [];
  List<Idea> _jarIdeas = [];
  List<Idea> _favIdeas = [];
  List<Widget> categoryChildren = [];

  DocumentSnapshot get selectedJar {
    return _selJar;
  }

  List<QuerySnapshot> get allJarIdeas {
    return _allJarIdeas;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get darkTheme {
    return _darkTheme;
  }

  List<dynamic> get usersJars {
    return _usersJars;
  }

  List<dynamic> get jarIdeas {
    return _jarIdeas;
  }

  List<Idea> get favIdeas {
    return _favIdeas;
  }

  void addJar(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    final user = await _auth.currentUser();
    CollectionReference jarCollection = _firestore.collection('jars');
    String imageLocation;
    data['categories'].insert(0, 'ALL');

    //first add jar locally
    final newJar = Jar(
      title: data['title'],
      categories: data['categories'],
      image: data['image'],
    );
    _usersJars.insert(1, newJar);
    _isLoading = false;
    notifyListeners();

    //after adding jar locally, add to db
    try {
      if (data['image'] != null) {
        imageLocation = await uploadJarImageToStorage(data['image']);
      }
      await jarCollection.document().setData(<String, dynamic>{
        'title': data['title'],
        'owners': FieldValue.arrayUnion([user.email]),
        'categories': data['categories'],
        'image': imageLocation == null ? null : imageLocation.toString(),
        'isFav': false
      });
    } catch (e) {
      print(e);
    }
  }

  void updateJar(Map<String, dynamic> data) async {
    String imageLocation;
    _isLoading = true;
    notifyListeners();

    //update jar locally first
    List<dynamic> newCategories = [];

    _usersJars.forEach((jar) {
      if (jar.title == _selJar['title']) {
        jar.categories.forEach((cat) => newCategories.add(cat));
        if (data['categoriesToAdd'].length > 0) {
          newCategories.add(data['categories']);
        }
        if (data['categoriesToRemove'].length > 0) {
          newCategories.remove(data['categoriesToRemove']);
        }
        jar = Jar(
            title: data['title'],
            categories: newCategories,
            image: data['image'] == null ? _selJar['image'] : data['image']);
      }
    });

    _isLoading = false;
    notifyListeners();
    //then update in db
    try {
      if (data['image'] != null) {
        imageLocation = await uploadJarImageToStorage(data['image']);
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
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void deleteJar() async {
    _usersJars.removeWhere((jar) => jar.title == _selJar['title']);
    notifyListeners();
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

  void deleteJarIdea(String id, String title) {
    _jarIdeas.removeWhere((idea) => idea.title == title);

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

  Future getJarBySelectedTitle(String title) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('jars').getDocuments().then((val) {
        val.documents.forEach((jar) {
          if (jar['title'] == title) {
            _selJar = jar;
          }
        });
      });
    } catch (e) {
      print(e);
    }
    return;
  }

  void resetIsLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void addToJar(String category, String title, String notes, String link,
      File image) async {
    String imageLocation;
    final uuid = Uuid();
    final newIdea = Idea(
        id: uuid.v4(),
        title: title,
        notes: notes,
        isFav: false,
        category: category,
        link: link,
        image: image != null
            ? image
            : _selJar['image'] != null
                ? _selJar['image']
                : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604');

    _jarIdeas.insert(0, newIdea);
    _isLoading = false;
    notifyListeners();
    try {
      if (image != null) {
        imageLocation = await uploadNoteImageToStorage(image);
        print(imageLocation);
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
        'image': imageLocation == null
            ? _selJar['image'] != null
                ? _selJar['image']
                : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604'
            : imageLocation.toString(),
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadNoteImageToStorage(File image) async {
    final StorageReference ref =
        FirebaseStorage.instance.ref().child('images').child('$image.jpg');
    //Upload the file to firebase
    StorageUploadTask uploadTask = ref.putFile(image);
    // Waits till the file is uploaded then stores the download url
    String location;
    try {
      await uploadTask.onComplete.then((val) async {
        await val.ref.getDownloadURL().then((val) {
          location = val;
        });
      });
    } catch (e) {
      print(e);
    }
    //returns the download url
    return location;
  }

  Future<String> uploadJarImageToStorage(File image) async {
    final StorageReference ref =
        FirebaseStorage.instance.ref().child('images').child('$image');
    //Upload the file to firebase
    StorageUploadTask uploadTask = ref.putFile(image);
    // Waits till the file is uploaded then stores the download url
    String location;
    try {
      await uploadTask.onComplete.then((val) async {
        await val.ref.getDownloadURL().then((val) {
          location = val;
        });
      });
    } catch (e) {
      print(e);
    }
    //returns the download url
    // print('LOCATION $location');
    return location;
  }

  void updateNote(Idea newIdea, String category, String title, String notes,
      String link, File image) async {
    _isLoading = true;
    notifyListeners();
    final Idea updatedIdea = Idea(
      title: newIdea.title,
      category: newIdea.category,
      link: newIdea.link,
      isFav: newIdea.getIsFav,
      image: newIdea.image == null ? _selJar['image'] : newIdea.image,
    );
    _jarIdeas.forEach((idea) {
      if (idea == newIdea) {
        idea = updatedIdea;
      }
    });

    _isLoading = false;
    notifyListeners();
    String imageLocation;
    try {
      if (image != null) {
        imageLocation = await uploadNoteImageToStorage(image);
      }
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document(newIdea.id)
          .updateData({
        'category': category == '' ? newIdea.category : category,
        'title': title,
        'notes': notes,
        'link': link,
        'isFav': newIdea.getIsFav,
        'image':
            imageLocation == null ? newIdea.image : imageLocation.toString()
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void toggleFavoriteStatus(Idea idea, int index) async {
    // _jarIdeas[index].setIsFav = !idea.getIsFav;
    _jarIdeas.forEach((val) {
      if(val == idea) {
        val.setIsFav = !idea.getIsFav;
      }
    });
    fetchFavoriteJarIdeas();
    notifyListeners();
    try {
      await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .document(idea.id)
          .updateData({'isFav': _jarIdeas[index].getIsFav});
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
        // print('created user because they did not exist yet');
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

  Future<List<dynamic>> fetchAllUserJarsFromDB(String email) async {
    _isLoading = true;
    notifyListeners();
    QuerySnapshot jars;
    FirebaseUser user = await _auth.currentUser();
    _usersJars = [_addJar];
    try {
      jars = await _firestore
          .collection('jars')
          .where('owners', arrayContains: email != null ? email : user.email)
          .getDocuments();
      jars.documents.forEach((jar) {
        final Jar newJar = Jar(
          title: jar['title'],
          categories: jar['categories'],
          image: jar['image'],
        );
        _usersJars.insert(1, newJar);
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      return e;
    }
    return _usersJars;
  }

  Future<List<dynamic>> fetchAllJarIdeasFromDB() async {
    _isLoading = true;
    notifyListeners();
    QuerySnapshot ideas;
    _jarIdeas = [];
    try {
      ideas = await _firestore
          .collection('jars')
          .document(_selJar.documentID)
          .collection('jarNotes')
          .getDocuments();
      ideas.documents.forEach((idea) {
        final Idea newIdea = Idea(
          id: idea.documentID,
          title: idea['title'],
          category: idea['category'],
          notes: idea['notes'],
          link: idea['link'],
          isFav: idea['isFav'] == null ? false : idea['isFav'],
          image: idea['image'],
        );
        _jarIdeas.add(newIdea);
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
      return e;
    }
    return _jarIdeas;
  }

  void fetchFavoriteJarIdeas() {
    _favIdeas = [];
    _jarIdeas.forEach((idea) {
      if (idea.getIsFav) {
        print('idea is fav ${idea.title}');
        _favIdeas.add(idea);
      }
    });
    print(_favIdeas);
    notifyListeners();
  }

  List<Idea> fetchJarNotesByCategory(String category) {
    List<Idea> _jarIdeasByCategory = [];

    if (_jarIdeas.length > 0) {
      if (category == 'ALL') {
        _jarIdeasByCategory = _jarIdeas;
      } else {
        _jarIdeas.forEach((idea) {
          if (idea.category == category) {
            _jarIdeasByCategory.add(idea);
          }
        });
      }
    } else {
      return null;
    }
    return _jarIdeasByCategory;
  }

  void launchURL(String url) async {
    if (!url.startsWith('https://') && !url.startsWith('http://')) {
      url = "https://$url";
    }
    if (isURL(url, protocols: ['https', 'http'])) {
      print('is URL');
      if (await canLaunch(url)) {
        // print('can launch this url!');
        await launch(url);
      } else {
        // print('can launch this url!');
        throw 'Could not launch $url';
      }
    }
  }

  Future<bool> getThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkTheme =
        prefs.getBool('darkTheme') != null ? prefs.getBool('darkTheme') : false;
    print(_darkTheme);
    notifyListeners();
    return _darkTheme;
  }

  void invertTheme() {
    _darkTheme = !_darkTheme;
    storeThemePref(_darkTheme);
    notifyListeners();
  }

  Future storeThemePref(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setBool('darkTheme', val);
    } catch (e) {
      print(e);
    }
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

  void resetUsersJars() {
    _usersJars = [];
    notifyListeners();
  }
}
