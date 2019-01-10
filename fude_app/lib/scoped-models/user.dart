import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fude/helpers/exceptions.dart';
import 'package:fude/models/recipe.dart';


mixin UserModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  var isLoading = false;
  var resetLinkSent = false;
  FirebaseUser get currentUser {
    return _currentUser;
  }

  Future<void> register({String email, String password}) async {
    isLoading = true;
    notifyListeners();
    FirebaseUser newUser;
    try {
      newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _currentUser = newUser;
      isLoading = false;
      notifyListeners();
    } catch (err) {
      isLoading = false;
      notifyListeners();
      throw new CausedException(
          cause: 'Firebase Auth',
          code: "3",
          message: 'register error',
          userMessage:
              "It looks like some of your info might be incorrect. Give it another shot.");
    }
  }

  Future<void> fetchUser() async {
    print('FETCHING USER');
    _currentUser = await _auth.currentUser();
    notifyListeners();
  }

  Future<void> login({String email, String password}) async {
    isLoading = true;
    notifyListeners();
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUser = user;
      print("successful login. User...");
      print(_currentUser);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      throw new CausedException(
          cause: 'Firebase Auth',
          code: "1",
          message: 'login error',
          userMessage:
              "It looks like your email and password might not match. Give it another shot.");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      throw new CausedException(
          cause: 'Firebase Auth',
          code: "2",
          message: 'logout error',
          userMessage:
              "We're having issues logging you out right nows, sorry about that.");
    }
  }

  void resetPassword(String email) async {
    print("sending reset password email...");
    try {
      _auth.sendPasswordResetEmail(email: email);
      resetLinkSent = true;
      notifyListeners();
      Timer(Duration(seconds: 3), () {
        resetLinkSent = false;
        notifyListeners();
      });
    } catch (e) {
      throw new CausedException(
          cause: 'Reset Password',
          code: "5",
          message: 'reset pass link send error',
          userMessage:
              "We're having issues sending you a reset link, sorry about that.");
    }
  }

  Future<void> createRecipe(Map<String, String> recipe) {
      
  }
}
