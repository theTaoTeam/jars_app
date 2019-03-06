import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/pages/home/recipes/recipe_edit.dart';

class RecipeCard extends StatelessWidget {
  final DocumentSnapshot recipe;

  RecipeCard({this.recipe});

  Widget _buildCategoryTitleRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(recipe['category'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(recipe['title'])
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ButtonBar(
            mainAxisSize: MainAxisSize.min,
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                iconSize: 20,
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  print('icon pressed');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return RecipeEditPage();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                iconSize: 20,
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  print('trying to favorite');
                },
              ),
            ]);
      
    
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _targetWidth =
        deviceWidth > 550.0 ? 100.0 : deviceWidth * 0.45;
    return Card(
      child: Row(
        children: <Widget>[
          FadeInImage(
            image: AssetImage('assets/tempfudeicon.png'),
            height: 100.0,
            width: _targetWidth,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/tempfudeicon.png'),
          ),
          Column(
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  _buildCategoryTitleRow(),
                ],
              ),
              _buildActionButtons(context),
            ],
          )
        ],
      ),
    );
    ;
  }
}
