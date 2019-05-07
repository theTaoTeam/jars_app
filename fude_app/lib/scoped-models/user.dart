import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fude/helpers/exceptions.dart';

mixin UserModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  var _isLoading = false;
  var resetLinkSent = false;
  String _currUserEmail;
  FirebaseUser get currentUser {
    return _currentUser;
  }

  String get currUserEmail {
    return _currUserEmail;
  }

  void fetchCurrentUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    _currUserEmail = user.email;
  }

  Future<void> register({String email, String password}) async {
    _isLoading = true;
    notifyListeners();
    FirebaseUser newUser;
    try {
      newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
    } catch (err) {
      _isLoading = false;
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
    _isLoading = true;
    notifyListeners();
    _currentUser = await _auth.currentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login({String email, String password}) async {
    _isLoading = true;
    notifyListeners();
    try {
      FirebaseUser user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _currentUser = user;
      _currUserEmail = _currentUser.email;
      print("successful login. User = $_currentUser");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw new CausedException(
          cause: 'Firebase Auth',
          code: "1",
          message: 'login error',
          userMessage:
              "Check your email and password and try again.");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _currUserEmail = null;
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
    _isLoading = true;
    notifyListeners();
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
    _isLoading = false;
    notifyListeners();
  }
}
