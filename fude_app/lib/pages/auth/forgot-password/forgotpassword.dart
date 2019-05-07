import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/animation.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fude/scoped-models/main.dart';

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

  void updateEmail(String email) {
    _emailInput = email;
  }

  void _resetPass({Function resetPassword}) async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      _formKey.currentState.save();

      resetPassword(_emailInput);
      Navigator.pop(context);
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
            decoration:
                BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Logo(isLogin: true),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
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
                                        isLogin: true,
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
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              animationStatus = 1;
                            });
                            _resetPass(resetPassword: model.resetPassword);
                          },
                          child: ForgotPassButton()),
                    )
                  ],
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Back to login',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.5,
                          color: Theme.of(context).primaryColor,
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
