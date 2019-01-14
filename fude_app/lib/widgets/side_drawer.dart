import 'package:flutter/material.dart';
import 'package:fude/scoped-models/main.dart';

Widget buildSideDrawer(BuildContext context, MainModel model) {
    return Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('email'),
                // accountEmail: model.currentUser.email != null ? Text(model.currentUser.email) : '',
              ),
              // Container(
              //   child: ListTile(
              //     title: Text('home'),
              //     onTap: () => Navigator.pushReplacementNamed(context, '/'),
              //   ),
              // ),
              Container(
                child: ListTile(
                  title: Text('favorites'),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text('all recipes'),
                  onTap: () => Navigator.pushNamed(context, '/allrecipes'),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text('logout'),
                  onTap: () => model.logout(),
                ),
              ),
            ],
          ),
        );
  }