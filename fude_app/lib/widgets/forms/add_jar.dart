import 'package:flutter/material.dart';

import 'package:fude/widgets/form-inputs/add_jar_inputs.dart';

class AddJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final Function updateTitle;

  AddJarForm({this.formKey, this.updateTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Form(
              key: formKey,
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AddJarInputField(
                    hint: "Title",
                    updateTitle: updateTitle,
                  ),
                  AddJarInputField(
                    hint: "Contributors",
                    // updateLink: updateLink,
                  ),
                  
                ],
              )),
        ],
      ),
    );
  }
}
