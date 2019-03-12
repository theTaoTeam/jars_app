import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';

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
      AssetImage image) async {
    try {
      String imageStorageLink = await uploadNoteImageToStorage(image.assetName);
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
        'image': imageStorageLink
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadNoteImageToStorage(String filepath) async {
    String _path;

    final ByteData bytes = await rootBundle.load(filepath);
    final Directory tempDir = Directory.systemTemp;
    final String fileName = "${Random().nextInt(1000)}.png";
    final File file = File('${tempDir.path}/$fileName');
    file.writeAsBytes(bytes.buffer.asInt8List(), mode: FileMode.write);

    final StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = ref.putFile(file);
    final Uri downloadUrl = (await task.future).downloadUrl;
    _path = downloadUrl.toString();
    print('_path: $_path');

    return _path;
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
