import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:fude/scoped-models/main.dart';

import 'package:fude/widgets/recipes/recipes.dart';
import 'package:fude/scoped-models/main.dart';

class AllRecipesPage extends StatefulWidget {
  final MainModel model;

  AllRecipesPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AllRecipesPageState();
  }
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  @override
  initState() {
    // widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildSideDrawer(MainModel model) {
    return Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('email'),
                accountEmail: Text(model.currentUser.email),
              ),
              Container(
                child: ListTile(
                  title: Text('home'),
                  onTap: () => Navigator.pushReplacementNamed(context, '/'),
                ),
              ),
              Container(
                child: ListTile(
                  title: Text('favorites'),
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildProductsList(MainModel model) {

        Widget content = Center(child: Text('No Products Found!'));
        // if (model.displayedProducts.length > 0 && !model.isLoading) {
          if(!model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        // return RefreshIndicator(onRefresh: model.fetchProducts, child: content,);
        return content;
    
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) { return Scaffold(
      drawer: _buildSideDrawer(model),
      appBar: AppBar(
        title: Text('All Recipes'),
      ),
      body: _buildProductsList(model),
    );});
  }
}
