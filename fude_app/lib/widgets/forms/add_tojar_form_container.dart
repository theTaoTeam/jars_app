import 'package:flutter/material.dart';

import 'package:fude/widgets/form-inputs/image.dart';
import 'package:fude/widgets/form-inputs/add_tojar_inputs.dart';

class AddToJarForm extends StatelessWidget {
  final GlobalKey formKey;
  final String selectedCategory;
  final bool nullCategory;
  final List<dynamic> categoryList;
  final Function updateCategory;
  final Function updateName;
  final Function updateLink;
  final Function updateNotes;
  final Function updateImage;

  AddToJarForm(
      {this.formKey,
      this.categoryList,
      this.selectedCategory,
      this.nullCategory,
      this.updateCategory,
      this.updateName,
      this.updateLink,
      this.updateNotes,
      this.updateImage});

  Widget _buildTextSections(String hint) {
    Function update;
    if (hint == "Name") {
      update = updateName;
    } else if (hint == "Link") {
      update = updateLink;
    } else if (hint == 'Notes') {
      update = updateNotes;
    }
    return AddToJarInput(
      hint: hint,
      update: update,
    );
  }

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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      color: Theme.of(context).primaryColor,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton(
                      hint: Text('CATEGORY',
                          style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor)),
                      value: selectedCategory,
                      items: categoryList.map((val) {
                        return DropdownMenuItem(
                          value: val.toString(),
                          child: Text(
                            val.toString(),
                            style:
                                TextStyle(color: val == selectedCategory ? Theme.of(context).secondaryHeaderColor : Color.fromRGBO(40, 40, 40, 1)),
                          ),
                        );
                      }).toList(),
                      onChanged: (dynamic val) {
                        updateCategory(val);
                      },
                    ),
                    nullCategory
                        ? Text(
                            'Please select a category',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Muli',
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          )
                        : Container(),
                  ],
                )
              ],
            ),
            SizedBox(height: 40),
            _buildTextSections('Name'),
            SizedBox(height: 30),
            _buildTextSections('Link'),
            SizedBox(height: 30),
            _buildTextSections('Notes'),
            SizedBox(height: 40),
            _buildFormTitles("IMAGE", context),
            SizedBox(height: 20),
            ImageInput(updateImage: updateImage),
          ],
        ),
      ),
    );
  }
}
