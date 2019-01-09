import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:fude/helpers/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin UserModel on Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  var isLoading = false;
  FirebaseUser get currentUser {
    return _currentUser;
  }

  Future<void> register(
      String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
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
              "It looks like some of your info is incorrect, give it another shot.");
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
              "It looks like your email and password don't match, give it another shot.");
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
              "We're having issues logging you out, sorry about that.");
    }
  }

  void resetPassword(String email) {
    print("sending reset password email...");
    _auth.sendPasswordResetEmail(email: email);
  }

  void _handleTimeoutError() {
    Timer(Duration(seconds: 20), () {
      isLoading = false;
      notifyListeners();
      throw new CausedException(
          cause: "Timeout Error",
          code: "4",
          message: "timeout error while authenticating user",
          userMessage:
              "Something went wrong, please check your network connection and try again!");
    });
  }
}
