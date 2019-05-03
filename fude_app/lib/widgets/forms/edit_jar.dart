import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/form-inputs/add_jar_name_input.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/widgets/form-inputs/add_jar_category_input.dart';
import 'package:fude/widgets/form-inputs/image.dart';

class EditJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final MainModel model;
  final List<dynamic> categories;
  final int categoryCount;
  final bool needsAtLeastOneCategory;
  final Function updateTitle;
  final Function updateCategory;
  final Function updateImage;
  final Function updateCategoryCount;
  final Function addCategoryToRemoveList;
  final DocumentSnapshot jar;

  EditJarForm(
      {this.formKey,
      this.model,
      this.categories,
      this.jar,
      this.categoryCount,
      this.needsAtLeastOneCategory,
      this.updateTitle,
      this.updateCategory,
      this.addCategoryToRemoveList,
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

  Column _buildExistingCategoryInputs(BuildContext context) {
    var children = <Widget>[];
    for (var i = 0; i <= categories.length - 1; i++) {
      children.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AddJarCategoryField(
              hint: categories[i],
              updateCategory: updateCategory,
              enabled: false,
              addCategoryToRemoveList: addCategoryToRemoveList,
              needsAtLeastOneCategory: needsAtLeastOneCategory,
            ),
            Text(
              'Tap and hold to delete',
              style: TextStyle(
                  color: Color.fromRGBO(131, 129, 129, 1), fontSize: 12),
            )
          ],
        ),
      );
    }
    return Column(
      children: children,
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
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildFormTitles("YOUR JAR NAME", context),
            SizedBox(height: height * 0.035),
            AddJarNameField(
              hint: jar['title'],
              updateTitle: updateTitle,
            ),
            SizedBox(height: height * 0.03),
            _buildFormTitles("CATEGORIES", context),
            needsAtLeastOneCategory
                ? Text(
                    'You need at least one category',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.start,
                  )
                : Container(),
            SizedBox(height: height * 0.01),
            _buildExistingCategoryInputs(context),
            categoryCount > 0 ? _addCategoryInputs() : Container(),
            SizedBox(height: height * 0.035),
            _buildFormTitles("JAR IMAGE", context),
            SizedBox(height: height * 0.03),
            ImageInput(
              updateImage: updateImage,
            ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}
