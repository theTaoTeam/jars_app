import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fude/scoped-models/main.dart';
import 'dart:async';
// import 'styles.dart';
import './resetAnimation.dart';
import 'package:fude/pages/auth/forgot-password/forgotpass_button.dart';
import 'package:fude/widgets/logo.dart';
import 'package:fude/widgets/form-inputs/input_fields.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgotPassState();
  }
}

class _ForgotPassState extends State<ForgotPassPage>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AnimationController _resetButtonController;
  var animationStatus = 0;

  String _emailInput;

  @override
  void initState() {
    super.initState();
    _resetButtonController = AnimationController(
        duration: Duration(milliseconds: 3000), vsync: this);
  }

  @override
  void dispose() {
    _resetButtonController.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation({Function resetPassword}) async {
    try {
      _resetPass(resetPassword);
      await _resetButtonController.forward();
      await _resetButtonController.reverse();
    } on TickerCanceled {}
  }

  void updateEmail(String email) {
    _emailInput = email;
  }

  void _resetPass(Function resetPassword) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

      resetPassword(_emailInput);
      Navigator.pop(context);
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
                            Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    InputFieldArea(
                                      hint: "Email",
                                      obscure: false,
                                      icon: Icons.person_outline,
                                      updateEmail: updateEmail,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: 160.0,
                                      ),
                                    ),
                                  ],
                                )),
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
                                      _playAnimation(
                                          resetPassword: model.resetPassword);
                                    },
                                    child: ForgotPassButton()),
                              )
                            : StaggerAnimation(
                                buttonController: _resetButtonController.view),
                      ],
                    ),
                  ],
                ))),
      );
    });
  }
}
