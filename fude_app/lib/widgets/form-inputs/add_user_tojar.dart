import 'package:flutter/material.dart';

class AddUserToJarField extends StatelessWidget {
  final String hint;
  final Function addUserToJar;
  final bool userHasBeenAdded;
  AddUserToJarField({this.hint, this.addUserToJar, this.userHasBeenAdded});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.05,
      width: width * 0.65,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.5,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: Theme.of(context).textTheme.caption.fontSize,
              letterSpacing: Theme.of(context).textTheme.caption.letterSpacing),
          decoration: InputDecoration(
            suffix: null,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
                color: Color.fromRGBO(131, 129, 129, 1), fontSize: 12),
            contentPadding:
                EdgeInsets.fromLTRB(height * 0.02, height * 0.01, 0, 0),
            errorStyle: TextStyle(
                color: Colors.red,
                fontSize: Theme.of(context).textTheme.caption.fontSize,
                letterSpacing:
                    Theme.of(context).textTheme.caption.letterSpacing),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (val) {
            String finalVal = val.toLowerCase();
            if (finalVal.isEmpty ||
                !RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(finalVal)) {
              return 'Please enter a valid email';
            }
          },
          onSaved: (val) {
            String finalVal = val.toLowerCase();
            addUserToJar(finalVal);
          }),
    );
  }
}
