import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';


import 'package:fude/models/recipe.dart';
import 'package:fude/scoped-models/main.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int productIndex;

  RecipeCard(this.recipe, this.productIndex);

  Widget _buildTitlePriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(recipe.title),
          SizedBox(
            width: 8.0,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => print('icon pressed'),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  print('trying to favorite');
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage('https://pbs.twimg.com/profile_images/1905139115/larry-david-mobile-wallpaper.jpg'),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/larry.jpg'),
          ),
          _buildTitlePriceRow(),
          Text('test'),
          _buildActionButtons(context)
        ],
      ),
    );
    ;
  }
}
