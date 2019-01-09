import 'dart:async';
import 'dart:convert';

import 'package:fude/.env.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:fude/models/auth.dart';
import 'package:fude/models/user.dart';

class ConnectedUserRecipeModel extends Model {}

mixin UserModel on ConnectedUserRecipeModel {
  String apiKey = API_KEY;
  User _authenticatedUser;
  bool _isLoading = false;
  PublishSubject<bool> _userSubject = PublishSubject();
  PublishSubject<bool> _themeSubject = PublishSubject();
  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  PublishSubject<bool> get themeSubject {
    return _themeSubject;
  }

  bool get isLoading {
    return _isLoading;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    final SharedPreferences prefs = await SharedPreferences
        .getInstance(); //gets required instance of device storage
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$apiKey',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$apiKey',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }
    bool hasError = true;
    String message = 'Something went wrong.';
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
        uid: responseData['localId'],
        email: email,
        token: responseData['refreshToken'],
        darkTheme: prefs.getBool('darkTheme') == null ? false : prefs.getBool('darkTheme'),
      );
      _userSubject.add(true);

      prefs.setString(
          'token', responseData['refreshToken']); //sets token in device storage
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setBool('darkTheme', _authenticatedUser.darkTheme);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }

    // print('USER: ${_authenticatedUser.email}');
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    print(prefs.getString('token'));
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final bool darkTheme = prefs.getBool('darkTheme');
      _authenticatedUser = User(
          uid: userId, email: userEmail, token: token, darkTheme: darkTheme);
      _userSubject.add(true);
      notifyListeners();
    }
  }

  Future<Null> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    print('About to send email to: $email');

    final Map<String, String> oobRequestBody = {
      'kind': "identitytoolkit#relyingparty",
      'requestType': "PASSWORD_RESET",
      'email': email,
    };
    http.Response getOob;
    try {
      getOob = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/getOobConfirmationCode?key=$apiKey',
        body: json.encode(oobRequestBody),
      );
    } catch (error) {
      print('OOB error: $error');
    }

    _isLoading = false;
    notifyListeners();

  }

  // Future<Null> startFacebookLogin() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final FacebookLogin facebookSignIn = new FacebookLogin();
  //   final FacebookLoginResult result =
  //       await facebookSignIn.logInWithReadPermissions(['email']);
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final FacebookAccessToken accessToken = result.accessToken;
  //       final SharedPreferences prefs = await SharedPreferences.getInstance();
  //       final String userEmail = prefs.getString('userEmail');
  //       var graphResponse = await http.get(
  //           'https://graph.facebook.com/v2.12/me?fields=name,email&access_token=${result.accessToken.token}');
  //       var profile = json.decode(graphResponse.body);
  //       print('''
  //        Logged in!
  //        device-storage: $userEmail
  //        accessToken: $accessToken
  //        Token: ${accessToken.token}
  //        User id: ${accessToken.userId}
  //        User profile: $profile
  //        Expires: ${accessToken.expires}
  //        Permissions: ${accessToken.permissions}
  //        Declined permissions: ${accessToken.declinedPermissions}
  //        ''');
  //       final Map<String, dynamic> authData = {
  //         'email': profile['email'],
  //         'password': profile['id'],
  //         'returnSecureToken': true,
  //       };
  //       http.Response response;
  //       response = await http.post(
  //         'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$apiKey',
  //         body: json.encode(authData),
  //         headers: {'Content-Type': 'application/json'},
  //       );
  //       final Map<String, dynamic> firstResponseData =
  //           json.decode(response.body);
  //       if (firstResponseData['error'] != null) {
  //         print('user not found. attempting to sign up ----------');
  //         response = await http.post(
  //           'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$apiKey',
  //           body: json.encode(authData),
  //           headers: {'Content-Type': 'application/json'},
  //         );
  //       }
  //       final Map<String, dynamic> responseData = json.decode(response.body);
  //       print('RESPONSE DATA $responseData');
  //       print(responseData['refreshToken']);
  //       if (responseData.containsKey('idToken')) {
  //         _userSubject.add(true);
  //         final SharedPreferences prefs = await SharedPreferences
  //             .getInstance(); //gets required instance of device storage
  //         prefs.setString('userEmail', responseData['email']);
  //         prefs.setString('userId', responseData['idToken']);
  //         prefs.setString('token', responseData['refreshToken']);
  //         _isLoading = false;
  //         notifyListeners();
  //       } else {
  //         print('something went wrong with the response $responseData');
  //         _isLoading = false;
  //         notifyListeners();
  //       }
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       print('Login cancelled by the user.');
  //       _isLoading = false;
  //       notifyListeners();
  //       break;
  //     case FacebookLoginStatus.error:
  //       print('Something went wrong with the login process.\n'
  //           'Here\'s the error Facebook gave us: ${result.errorMessage}');
  //       break;
  //   }
  // }

  void logout() async {
    _isLoading = true;
    notifyListeners();
    _userSubject.add(false);
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    prefs.remove('darkTheme');
    _isLoading = false;
    notifyListeners();

  }

  // Future<Null> fetchUserSettings() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final email = prefs.getString('userEmail');
  //   final theme = prefs.getBool('darkTheme');
  //   print("USER IN FETCHSETTINGS $_authenticatedUser");
  //   _authenticatedUser = new User(
  //     uid: _authenticatedUser.uid,
  //     email: email,
  //     token: _authenticatedUser.token,
  //     darkTheme: theme,
  //   );
  //   _isLoading = false;
  //   notifyListeners();
  //   return;
  // }

  // Future<Null> saveUserSettings(Map<String, dynamic> settings) async {
  //   _isLoading = true;
  //   _themeSubject.add(settings['darkTheme']);
  //   notifyListeners();
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('userEmail', settings['email']);
  //   prefs.setBool('darkTheme', settings['darkTheme']);
  //   // print(_authenticatedUser);
  //   _authenticatedUser = User(
  //     uid: _authenticatedUser.uid,
  //     email: settings['email'],
  //     token: _authenticatedUser.token,
  //     darkTheme: settings['darkTheme'],
  //   );
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // void getUserTheme(bool darkTheme) {
  //   _isLoading = true;
  //   notifyListeners();
  //   print('theme subject: $_themeSubject');
  //   _themeSubject.add(darkTheme);

  //   _isLoading = false;
  //   notifyListeners();
  // }
}
