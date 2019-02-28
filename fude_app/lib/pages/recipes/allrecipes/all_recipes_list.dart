import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    // widget.model.fetchRecipes();
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit, color: Colors.white),
      onPressed: () {
        // model.selectRecipe(model.allRecipes[index].id);
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
        return StreamBuilder(
            stream: Firestore.instance.collection('recipes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading...');
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(snapshot.data.doc[index].title),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        // model.selectRecipe(snapshot.data.doc.uid);
                        print(snapshot.data.doc.uid);
                        // model.deleteProduct();
                      } else if (direction == DismissDirection.startToEnd) {
                        print('Swiped start to end');
                      } else {
                        print('Other swiping');
                      }
                      print('Dissmissed attempt');
                    },
                    background: Container(color: Colors.red),
                    child: Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.grey),),
                      child: ListTile(
                        leading: CircleAvatar(),
                        title: Text(snapshot.data.doc[index].title,
                            style: TextStyle(color: Colors.white)),
                        trailing: _buildEditButton(context, index, model),
                      ),
                    ),
                  );
                },
                itemCount: 5,
              );
            });
      },
    );
  }
}
