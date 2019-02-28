import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:fude/models/recipe.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/recipes/allrecipes/recipe_edit.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int index;

  RecipeCard(this.recipe, this.index);

  Widget _buildCategoryRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(recipe.category, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: 8.0,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow() {
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

  Widget _buildDescriptionPriceRow() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(recipe.notes),
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
                onPressed: () {
                  print('icon pressed');
                  // model.selectRecipe(model.allRecipes[index].id);
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
            image: recipe.link != null
                ? NetworkImage(recipe.link)
                : AssetImage('assets/tempfudeicon.png'),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/tempfudeicon.png'),
          ),
          _buildCategoryRow(),
          _buildTitleRow(),
          _buildDescriptionPriceRow(),
          _buildActionButtons(context)
        ],
      ),
    );
    ;
  }
}
