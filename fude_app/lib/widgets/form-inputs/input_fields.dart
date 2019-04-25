import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final bool isLogin;
  final IconData icon;
  final Function updateEmail;
  final Function updatePassword;
  InputFieldArea(
      {this.hint,
      this.obscure,
      this.isLogin,
      this.icon,
      this.updateEmail,
      this.updatePassword});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      child: TextFormField(
        obscureText: obscure,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        keyboardType: hint == 'Email' ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 32,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15.0,
              letterSpacing: 5),
          contentPadding:
              EdgeInsets.only(top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
        validator: (String val) {
          String finalVal = val.toLowerCase();
          if (hint == 'Email') {
            print(finalVal);
            if (finalVal.isEmpty ||
                !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(finalVal)) {
              return 'Check your email';
            }
          } else if (hint == 'Password') {
            if (finalVal.isEmpty || finalVal.length < 8) {
              return isLogin
                  ? 'Check your password'
                  : 'Must be 8 characters';
            }
          }
        },
        onSaved: (String val) {
          print(val);
          hint == 'Email' ? updateEmail(val) : updatePassword(val);
        },
      ),
    );
  }
}
