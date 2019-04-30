import 'package:flutter/material.dart';
import 'package:fude/scoped-models/main.dart';

import 'package:fude/widgets/form-inputs/add_user_tojar.dart';

class AddUserToJarForm extends StatelessWidget {
  final GlobalKey addUserFormKey;
  final Function addUserToJar;
  final Function submitAddUser;
  final bool userHasBeenAdded;
  final bool needToInviteThisUser;
  final MainModel model;

  AddUserToJarForm(
      {this.addUserFormKey,
      this.addUserToJar,
      this.submitAddUser,
      this.userHasBeenAdded,
      this.needToInviteThisUser,
      this.model});

  Widget _buildFormTitles(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      child: Form(
          key: addUserFormKey,
          autovalidate: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: height * 0.03),
              _buildFormTitles('SHARE WITH SOMEONE', context),
              SizedBox(height: height * 0.02),
              Row(
                children: <Widget>[
                  AddUserToJarField(
                    hint: 'email',
                    addUserToJar: addUserToJar,
                    userHasBeenAdded: userHasBeenAdded,
                  ),
                  model.isLoading
                      ? CircularProgressIndicator(
                          backgroundColor: Colors.transparent, strokeWidth: 4)
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () => submitAddUser(),
                          color: Theme.of(context).iconTheme.color,
                        )
                ],
              ),
              userHasBeenAdded
                  ? Container(
                      padding: EdgeInsets.only(left: width * 0.04),
                      child: Text(
                        'Added!',
                        style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize:
                                Theme.of(context).textTheme.caption.fontSize,
                            letterSpacing: Theme.of(context)
                                .textTheme
                                .caption
                                .letterSpacing),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : Container(),
              needToInviteThisUser
                  ? Container(
                      padding: EdgeInsets.only(left: width * 0.04),
                      child: Text(
                        "This user doesn't have an account yet. Please have them create one before sharing!",
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize:
                                Theme.of(context).textTheme.caption.fontSize,
                            letterSpacing: Theme.of(context)
                                .textTheme
                                .caption
                                .letterSpacing),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : Container()
            ],
          )),
    );
  }
}
