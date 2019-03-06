import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_jar.dart';
import 'package:fude/scoped-models/main.dart';

class AddJarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddJarPageState();
  } 
}

class _AddJarPageState extends State<AddJarPage> {
  final Map<String, String> _formData = {
    'title': '',
  };
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  void addJar(MainModel model) {
    // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      print('form saved.....sending to model');
    }
      model.addJar(_formData['title']);
  }

  void updateTitle(String val) {
    print('update title called: $_formData');
    setState(() {
      _formData['title'] = val;
    });
    print('formData: $_formData');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(0, 0, 0, 0.15), BlendMode.dstATop),
                image: AssetImage('assets/logo.png'),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(204, 43, 94, 1),
                  Color.fromRGBO(117, 58, 136, 1),
                ],
                stops: [0.2, 1.0],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0),
              )),
          child: ListView(
            padding: EdgeInsets.only(top: deviceHeight * 0.05),
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AddJarForm(formKey: formKey, updateTitle: updateTitle),
                      model.isLoading
                          ? CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                print('add jar tapped');
                                addJar(model);
                              },
                              child: Container(
                                width: 320.0,
                                height: 60.0,
                                margin: EdgeInsets.only(top: 20),
                                alignment: FractionalOffset.center,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(247, 64, 106, 1.0),
                                  borderRadius: BorderRadius.all(
                                      const Radius.circular(30.0)),
                                ),
                                child: Text(
                                  "add jar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
