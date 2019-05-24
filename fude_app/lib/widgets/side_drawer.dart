import 'package:flutter/material.dart';

import 'package:jars/scoped-models/main.dart';

Widget buildSideDrawer(BuildContext context, MainModel model) {
  _navToAddJarForm() {
      Navigator.popAndPushNamed(context, '/addjar');  
  }

  return Drawer(
      child: Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
      colors: <Color>[
        Color.fromRGBO(204, 43, 94, 1),
        Color.fromRGBO(117, 58, 136, 1),
      ],
      stops: [0.2, 1.0],
      begin: FractionalOffset(0.0, 0.0),
      end: FractionalOffset(0.0, 1.0),
    )),
    child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.transparent),
          accountName: Text('füde', style: TextStyle(fontSize: 35),),
          accountEmail: Text('powered by The Tao Team', style: TextStyle(fontSize: 10),),
        ),
        Container(
          child: ListTile(
            title: Text('home', style: TextStyle(color: Colors.white),),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ),
        Container(
          child: ListTile(
            title: Text('add jar', style: TextStyle(color: Colors.white)),
            onTap: () => _navToAddJarForm(),
          ),
        ),
        Container(
          child: ListTile(
            title: Text('logout', style: TextStyle(color: Colors.white)),
            onTap: () => model.logout(),
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 1,
          margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
          alignment: Alignment.centerLeft,
          child: Text(
            'favortites',
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
          ),
        ),
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[
        //     RecipeListPage(model),
        //   ],
        // )
      ],
    ),
  ));
}
