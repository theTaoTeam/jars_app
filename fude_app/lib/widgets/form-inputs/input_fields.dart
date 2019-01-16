import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  final Function updateEmail;
  final Function updatePassword;
  InputFieldArea(
      {this.hint,
      this.obscure,
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
            color: Colors.white24,
          ),
        ),
      ),
      child: TextFormField(
        obscureText: obscure,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white, fontSize: 15.0),
          contentPadding: EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
        onSaved: (String val) {
          print(val);
          hint == 'Email' ? updateEmail(val) : updatePassword(val);
        },
      ),
    );
  }
}
