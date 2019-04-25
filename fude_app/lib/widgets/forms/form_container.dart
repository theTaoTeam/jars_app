import 'package:flutter/material.dart';
import 'package:fude/widgets/form-inputs/input_fields.dart';

class FormContainer extends StatelessWidget {
  final GlobalKey formKey;
  final Function updateEmail;
  final Function updatePassword;
  final bool isLogin;
  FormContainer(
      {this.formKey, this.updateEmail, this.updatePassword, this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    isLogin: isLogin,
                  ),
                  InputFieldArea(
                    hint: "Password",
                    obscure: true,
                    icon: Icons.lock_outline,
                    updatePassword: updatePassword,
                    isLogin: isLogin,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
