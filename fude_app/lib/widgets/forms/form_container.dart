import 'package:flutter/material.dart';
import './input_fields.dart';

class FormContainer extends StatelessWidget {
  final GlobalKey formKey;
  final Function updateEmail;
  final Function updatePassword;

  FormContainer({this.formKey, this.updateEmail, this.updatePassword});

  @override
  Widget build(BuildContext context) {
    return (Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InputFieldArea(
                    hint: "Email",
                    obscure: false,
                    icon: Icons.person_outline,
                    updateEmail: updateEmail,
                  ),
                  InputFieldArea(
                    hint: "Password",
                    obscure: true,
                    icon: Icons.lock_outline,
                    updatePassword: updatePassword,
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}
