import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:jars/scoped-models/main.dart';

import 'package:jars/pages/auth/signup/forgotpass_link.dart';

import 'package:jars/pages/auth/signup/signup_button.dart';
import 'package:jars/helpers/exceptions.dart';
import 'package:jars/widgets/forms/form_container.dart';
import 'package:jars/widgets/logo.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AnimationController _signupButtonController;
  var animationStatus = 0;
  final bool isLogin = false;

  final Map<String, String> _formData = {
    'email': null,
    'password': null,
  };

  @override
  void initState() {
    super.initState();
    _signupButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _signupButtonController.dispose();
    super.dispose();
  }

  void updateEmail(String email) {
    _formData['email'] = email;
    // print('Email saved: ' + _formData['email']);
  }

  void updatePassword(String password) {
    _formData['password'] = password;
    // print('Password saved: ' + _formData['password']);
  }

  void _submitForm({Function register}) async {
    // print("about to register");
    if (!formKey.currentState.validate()) {
      return;
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      formKey.currentState.save();
      try {
        await register(
            email: _formData['email'], password: _formData['password']);
        Navigator.pushReplacementNamed(context, '/');
      } on CausedException catch (exc) {
        exc.debugPrint();
        _showErrorDialog(context: context, userMessage: exc.userMessage);
      } catch (e) {
        _showErrorDialog(
          context: context,
        );
      }
    }
  }

  void _showErrorDialog({BuildContext context, String userMessage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Oops!',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          content: Text(userMessage),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    // final double height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Logo(isLogin: false),
                        FormContainer(
                            formKey: formKey,
                            updateEmail: updateEmail,
                            updatePassword: updatePassword,
                            isLogin: isLogin),
                        ForgotPassword(),
                      ],
                    ),
                    !model.isLoading
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 50.0),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    animationStatus = 1;
                                  });
                                  model.resetUsersJars();
                                  _submitForm(register: model.register);
                                },
                                child: SignUpButton()),
                          )
                        : Padding(
                            padding: EdgeInsets.only(bottom: 50.0),
                            child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).primaryColor,
                              strokeWidth: 4,
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Back to login',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 12.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
