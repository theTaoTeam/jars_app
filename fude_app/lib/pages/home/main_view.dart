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
            color: Color.fromRGBO(100, 50, 115, 1),
          ),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicatorColor: Color(0x00000000),
            tabs: <Widget>[
              Container(
                height: 150,
                child: Tab(
                  text: 'jars',
                ),
              ),
              Container(
                height: 150,
                child: Tab(
                  text: 'recipes',
                ),
              )
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(0, 0, 0, 0.15), BlendMode.dstATop),
                image: AssetImage('assets/logo.png'),
              ),
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromRGBO(204, 43, 94, 1),
                  Color.fromRGBO(117, 58, 136, 1),
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
