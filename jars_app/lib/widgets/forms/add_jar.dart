import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:jars/widgets/form-inputs/add_jar_name_input.dart';
import 'package:jars/widgets/form-inputs/add_jar_category_input.dart';
import 'package:jars/widgets/form-inputs/image.dart';
import 'package:jars/scoped-models/main.dart';

class AddJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final int categoryCount;
  final bool imageSelected;
  final bool needsAtLeastOneCategory;
  final Function updateTitle;
  final Function updateCategory;
  final Function updateImage;
  final Function updateCategoryCount;
  final DocumentSnapshot jar;
  final List<dynamic> categories;
  final MainModel model;

  AddJarForm(
      {this.formKey,
      this.jar,
      this.imageSelected,
      this.needsAtLeastOneCategory,
      this.categoryCount,
      this.updateTitle,
      this.updateCategory,
      this.updateImage,
      this.updateCategoryCount,
      this.categories,
      this.model});

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
                  _addCategoryInputs();
                })
            : Container()
      ],
    );
  }

  Column _addCategoryInputs() {
    model.categoryChildren.add(
      Column(
        children: <Widget>[
          AddJarCategoryField(
            hint: 'Add Category',
            updateCategory: updateCategory,
            model: model,
            enabled: true,
            categories: categories,
          ),
        ],
      ),
    );

    return Column(
      children: model.categoryChildren,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;
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
              Column(
                children: model.categoryChildren,
              ),
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
