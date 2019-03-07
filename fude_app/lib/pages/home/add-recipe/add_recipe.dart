import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/widgets/forms/add_tojar_form_container.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/side_drawer.dart';

class AddRecipePage extends StatefulWidget {
  final List<dynamic> categories;

  AddRecipePage({this.categories});

  @override
  State<StatefulWidget> createState() {
    return _AddRecipePageState();
  }
}

class _AddRecipePageState extends State<AddRecipePage> {
  String selectedCategory;
  String selectedJar;
  MainModel model = MainModel();
  List<String> jarList;

  final Map<String, dynamic> _formData = {
    'category': '',
    'jar': '',
    'title': '',
    'link': '',
    'notes': '',
    'image': AssetImage('assets/logo.png'),
  };

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void addRecipe(MainModel model) {
    // First validate form.
    if (this.formKey.currentState.validate()) {
      formKey.currentState.save(); // Save our form now.
      model.addRecipe(
          _formData['category'],
          _formData['jar'],
          _formData['title'],
          _formData['notes'],
          _formData['link'],
          _formData['image']);
    }
  }

  void updateCategory(dynamic value) {
    setState(() {
      selectedCategory = value;
      _formData['category'] = value;
    });
  }

  void updateJar(dynamic value) {
    setState(() {
      selectedJar = value;
      _formData['jar'] = value;
    });
  }

  void updateTitle(String value) {
    setState(() {
      _formData['title'] = value;
    });
  }

  void updateLink(String value) {
    setState(() {
      _formData['link'] = value;
    });
  }

  void updateNotes(String value) {
    setState(() {
      _formData['notes'] = value;
    });
  }

  void updateImage(Image image) {
    setState(() {
      _formData['image'] = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(175, 31, 82, 1),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      drawer: buildSideDrawer(context, model),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.red,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return Container(
          width: deviceWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color.fromRGBO(0, 0, 0, 0.15), BlendMode.dstATop),
              image: AssetImage('assets/logo.png'),
            ),
          ),
          child: ListView(
            padding: EdgeInsets.only(top: deviceHeight * 0.05),
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      AddToJarForm(
                        formKey: formKey,
                        categoryList: widget.categories,
                        selectedCategory: selectedCategory,
                        updateCategory: updateCategory,
                        updateTitle: updateTitle,
                        updateLink: updateLink,
                        updateNotes: updateNotes,
                        updateImage: updateImage,
                      ),
                      model.isLoading
                          ? CircularProgressIndicator()
                          : GestureDetector(
                              onTap: () {
                                print('add to jar tapped');
                                addRecipe(model);
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
                                  "add to jar",
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
        );
      }),
    );
  }
}
