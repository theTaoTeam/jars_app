import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fude/scoped-models/main.dart';
import 'dart:async';
import 'styles.dart';
import 'loginAnimation.dart';
import 'package:fude/pages/auth/signup/signup_link.dart';
import 'package:fude/widgets/forms/form_container.dart';
import 'package:fude/pages/auth/login/login_button.dart';
import 'package:fude/widgets/logo.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AnimationController _loginButtonController;
  var animationStatus = 0;

  final Map<String, String> _formData = {
    'email': null,
    'password': null,
  };

  @override
  void initState() {
    super.initState();
    _loginButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation({Function login}) async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
      _submitForm(login: login);
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

  void _submitForm({Function login}) async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();

    try {
      await login(_formData['email'], _formData['password']);
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print(e.toString());
      try {
        print(e.cause);
      } catch (e) {
        print("couldn't print cause");
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aw Geeze!'),
            content: Text("Error"),
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
                            SignUp()
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
                                      _playAnimation(login: model.login);
                                    },
                                    child: LoginInButton()),
                              )
                            : StaggerAnimation(
                                buttonController: _loginButtonController.view),
                      ],
                    ),
                  ],
                ))),
      );
    });
  }
}
