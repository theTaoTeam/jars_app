import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/form-inputs/add_jar_name_input.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/form-inputs/add_jar_category_input.dart';
import 'package:fude/widgets/form-inputs/image.dart';

class EditJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final MainModel model;
  final int categoryCount;
  final Function updateTitle;
  final Function updateCategory;
  final Function updateImage;
  final Function updateCategoryCount;
  final DocumentSnapshot jar;

  EditJarForm(
      {this.formKey,
      this.model,
      this.jar,
      this.categoryCount,
      this.updateTitle,
      this.updateCategory,
      this.updateImage,
      this.updateCategoryCount});

  Widget _buildFormTitles(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: title == "CATEGORIES"
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 3,
          ),
          textAlign: TextAlign.start,
        ),
        title == "CATEGORIES"
            ? IconButton(
                icon: Icon(Icons.add),
                iconSize: 36,
                color: Theme.of(context).iconTheme.color,
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
              model: model,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildFormTitles("YOUR JAR NAME", context),
              SizedBox(height: 40),
              AddJarNameField(
                hint: jar['title'],
                updateTitle: updateTitle,
              ),
              SizedBox(height: 40),
              _buildFormTitles("CATEGORIES", context),
              SizedBox(height: 40),
              _buildExistingCategoryInputs(),
              categoryCount > 0 ? _addCategoryInputs() :Container(),
              SizedBox(height: 40),
              _buildFormTitles("HOW ABOUT AN IMAGE?", context),
              SizedBox(height: 30),
              ImageInput(
                updateImage: updateImage,
              )
            ],
          )),
    );
  }
}
