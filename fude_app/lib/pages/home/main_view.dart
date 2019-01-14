import 'package:flutter/material.dart';

import 'package:fude/pages/home/add-recipe/add_recipe.dart';
import 'package:fude/pages/home/get-recipe/get_recipe.dart';

class MainView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(51, 51, 63, 0.9),
              Color.fromRGBO(51, 51, 63, 1),
            ],
            stops: [0.2, 1.0],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.0, 1.0),
          )),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Color(0x00000000),
            tabs: <Widget>[
              Container(
                height: 200,
                child: Tab(
                  text: 'categories',
                ),
              ),
              Container(
                height: 200,
                child: Tab(
                  text: 'add recipe',
                ),
              )
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: <Color>[
              Color.fromRGBO(162, 146, 199, 0.8),
              Color.fromRGBO(51, 51, 63, 0.9),
            ],
            stops: [0.2, 1.0],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(0.0, 1.0),
          )),
          child: TabBarView(
            children: <Widget>[GetRecipePage(), AddRecipePage()],
          ),
        ),
      ),
    );
  }
}
