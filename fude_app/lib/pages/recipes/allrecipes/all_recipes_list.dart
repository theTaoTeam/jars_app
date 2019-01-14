import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/scoped-models/main.dart';

import 'package:fude/pages/recipes/allrecipes/recipe_edit.dart';

class RecipeListPage extends StatefulWidget {
  final MainModel model;

  RecipeListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RecipeListPageState();
  }
}

class _RecipeListPageState extends State<RecipeListPage> {
  @override
  initState() {
    widget.model.fetchRecipes();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        // model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return RecipeEditPage();
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              // key: Key(model.allProducts[index].title),
              key: Key('1'),
              onDismissed: (DismissDirection direction) {
                // if (direction == DismissDirection.endToStart) {
                //   model.selectProduct(model.allProducts[index].id);
                //   model.deleteProduct();
                // } else if (direction == DismissDirection.startToEnd) {
                //   print('Swiped start to end');
                // } else {
                //   print('Other swiping');
                // }
                print('Dissmissed attempt');
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(),
                    title: Text('Test'),
                    subtitle: Text('subtitle test'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: 5,
        );
      },
    );
  }
}
