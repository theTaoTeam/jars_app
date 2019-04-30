import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/form-inputs/add_jar_name_input.dart';
import 'package:fude/widgets/form-inputs/add_jar_category_input.dart';
import 'package:fude/widgets/form-inputs/image.dart';

class AddJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final int categoryCount;
  final Function updateTitle;
  final Function updateCategory;
  final Function updateImage;
  final Function updateCategoryCount;
  final DocumentSnapshot jar;
  final List<dynamic> categories;

  AddJarForm(
      {this.formKey,
      this.jar,
      this.categoryCount,
      this.updateTitle,
      this.updateCategory,
      this.updateImage,
      this.updateCategoryCount,
      this.categories});

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

  Column _addCategoryInputs(BuildContext context) {
    var children = <Widget>[];
    for (var i = 0; i < categoryCount; i++) {
      children.add(
        Column(
          children: <Widget>[
            AddJarCategoryField(
              hint: 'Add Category',
              updateCategory: updateCategory,
              enabled: true,
                categories: categories,

            ),
          ],
        ),
      );
    }
    return Column(
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Form(
          key: formKey,
          autovalidate: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildFormTitles("JAR NAME", context),
              SizedBox(height: height * 0.035),
              AddJarNameField(
                hint: jar == null ? 'Name' : jar['title'],
                updateTitle: updateTitle,
              ),
              SizedBox(height: height * 0.035),
              _buildFormTitles("CATEGORIES", context),
              SizedBox(height: height * 0.01),
              AddJarCategoryField(
                hint: 'Add Category',
                updateCategory: updateCategory,
                enabled: true,
                categories: categories,
              ),
              categoryCount > 0 ? _addCategoryInputs(context) : Container(),
              SizedBox(height: height * 0.035),
              _buildFormTitles("JAR IMAGE", context),
              SizedBox(height: height * 0.03),
              ImageInput(
                updateImage: updateImage,
              )
            ],
          )),
    );
  }
}
