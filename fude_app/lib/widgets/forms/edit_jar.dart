import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/form-inputs/add_jar_name_input.dart';
import 'package:fude/widgets/form-inputs/add_jar_category_input.dart';
import 'package:fude/widgets/form-inputs/image.dart';

class EditJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final int categoryCount;
  final Function updateTitle;
  final Function updateCategory;
  final Function updateImage;
  final Function updateCategoryCount;
  final DocumentSnapshot jar;

  EditJarForm(
      {this.formKey,
      this.jar,
      this.categoryCount,
      this.updateTitle,
      this.updateCategory,
      this.updateImage,
      this.updateCategoryCount});

  Widget _buildFormTitles(String title) {
    return Row(
      mainAxisAlignment: title == "CATEGORIES"
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style:
              TextStyle(color: Color.fromRGBO(236, 240, 241, 1), fontSize: 16),
          textAlign: TextAlign.start,
        ),
        title == "CATEGORIES"
            ? IconButton(
                icon: Icon(Icons.add_circle_outline),
                iconSize: 20,
                color: Color.fromRGBO(236, 240, 241, 0.7),
                onPressed: () {
                  updateCategoryCount();
                })
            : Container()
      ],
    );
  }

  Column _buildExistingCategoryInputs() {
    print(jar['categories']);
    var children = <Widget>[];
    for (var i = 0; i <= jar['categories'].length - 1; i++) {
      children.add(
        Column(
          children: <Widget>[
            AddJarCategoryField(
              hint: jar['categories'][i],
              updateCategory: updateCategory,
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
    return Column(children: children,);
  }

  Column _addCategoryInputs() {
    var children = <Widget>[];
    for (var i = 0; i < categoryCount; i++) {
      children.add(
        Column(
          children: <Widget>[
            AddJarCategoryField(
              hint: 'Category',
              updateCategory: updateCategory,
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    }
    return Column(children: children,);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
          key: formKey,
          autovalidate: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildFormTitles("YOUR JAR NAME"),
              SizedBox(height: 40),
              AddJarNameField(
                hint: jar['title'],
                updateTitle: updateTitle,
              ),
              SizedBox(height: 40),
              _buildFormTitles("CATEGORIES"),
              SizedBox(height: 40),
              _buildExistingCategoryInputs(),
              categoryCount > 0 ? _addCategoryInputs() :Container(),
              SizedBox(height: 40),
              _buildFormTitles("HOW ABOUT AN IMAGE?"),
              SizedBox(height: 30),
              ImageInput(
                updateImage: updateImage,
              )
            ],
          )),
    );
  }
}
