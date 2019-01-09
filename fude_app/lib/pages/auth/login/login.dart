import 'package:flutter/material.dart';
import 'styles.dart';
import 'loginAnimation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'dart:async';
import '../signup/signup_link.dart';
import '../../../widgets/forms/form_container.dart';
import './login_button.dart';
import '../../../widgets/logo.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);
  @override
    State<StatefulWidget> createState() {
      return _LoginPageState();
    }
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  var animationStatus = 0;
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

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          child: AlertDialog(
            title: Text('Are you sure?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/home"),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return (WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Container(
              decoration: BoxDecoration(
                image: backgroundImage,
              ),
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
                              FormContainer(),
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
                                        _playAnimation();
                                      },
                                      child: LoginInButton()),
                                )
                              : StaggerAnimation(
                                  buttonController:
                                      _loginButtonController.view),
                        ],
                      ),
                    ],
                  ))),
        )));
  }
}