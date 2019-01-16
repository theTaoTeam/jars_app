import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fude/scoped-models/main.dart';
import 'dart:async';
import 'styles.dart';
import './signupAnimation.dart';
import 'package:fude/pages/auth/signup/forgotpass_link.dart';
import 'package:fude/pages/auth/signup/signup_button.dart';
import 'package:fude/helpers/exceptions.dart';
import 'package:fude/widgets/forms/form_container.dart';
import 'package:fude/widgets/logo.dart';

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

  Future<Null> _playAnimation({Function register}) async {
    try {
      _submitForm(register: register);
      await _signupButtonController.forward();
      await _signupButtonController.reverse();
    } on TickerCanceled {}
  }

  void updateEmail(String email) {
    _formData['email'] = email;
    print('Email saved: ' + _formData['email']);
  }

  void updatePassword(String password) {
    _formData['password'] = password;
    print('Password saved: ' + _formData['password']);
  }

  void _submitForm({Function register}) async {
    print("about to register");
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    try {
      await register(email: _formData['email'], password: _formData['password']);
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

   void _showErrorDialog({BuildContext context, String userMessage}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops!'),
          content: Text(userMessage),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: <Color>[
                    const Color.fromRGBO(162, 146, 199, 0.8),
                    const Color.fromRGBO(51, 51, 63, 0.9),
                  ],
                  stops: [0.2, 1.0],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                )),
                child: ListView(
                  padding: const EdgeInsets.all(0.0),
                  children: <Widget>[
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Logo(),
                            FormContainer(
                                formKey: formKey,
                                updateEmail: updateEmail,
                                updatePassword: updatePassword),
                            ForgotPassword()
                          ],
                        ),
                        animationStatus == 0
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 50.0),
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        animationStatus = 1;
                                      });
                                      _playAnimation(register: model.register);
                                      
                                    },
                                    child: SignUpButton()),
                              )
                            : StaggerAnimation(
                                buttonController: _signupButtonController.view),
                      ],
                    ),
                  ],
                ))),
      );
    });
  }
}
