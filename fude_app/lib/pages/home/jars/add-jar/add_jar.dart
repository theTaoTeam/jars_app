import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_jar.dart';
import 'package:fude/scoped-models/main.dart';

class AddJarPage extends StatefulWidget {
  final bool addingRecipe;

  AddJarPage({this.addingRecipe});
  @override
  State<StatefulWidget> createState() {
    return _AddJarPageState();
  }
}

class _AddJarPageState extends State<AddJarPage> {
  final Map<String, dynamic> _formData = {
    'title': '',
    'category': [],
  };
  var categoryCount = 1;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void addJar(MainModel model) {
    // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      print('form saved.....sending to model');
    }
    model.addJar(_formData['title'], _formData['category']);
    Navigator.pop(context);
  }

  void incrementCategoryCount() {
    setState(() {
      categoryCount += 1;
    });
  }

  void updateTitle(String val) {
    print('update title called: $_formData');
    setState(() {
      _formData['title'] = val;
    });
  }

  void updateCategory(String val) {
    print('update category called: $_formData');
    setState(() {
      _formData['category'].add(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(175, 31, 82, 1),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.15), BlendMode.dstATop),
              image: AssetImage('assets/logo.png'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AddJarForm(
                formKey: formKey,
                updateTitle: updateTitle,
                updateCategory: updateCategory,
                incrementCategoryCount: incrementCategoryCount,
              ),
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
                        alignment: FractionalOffset.center,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius:
                              BorderRadius.all(const Radius.circular(30.0)),
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
        ),
      );
    });
  }
}
