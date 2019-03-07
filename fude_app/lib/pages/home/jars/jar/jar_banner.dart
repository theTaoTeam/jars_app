import 'package:flutter/material.dart';

import 'package:fude/pages/home/add-recipe/add_recipe.dart';

class JarBanner extends StatelessWidget {
  final List<dynamic> categories;

  JarBanner({this.categories});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.width;
    return Container(
        height: deviceHeight * 0.75,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecipePage(categories: categories),
                    ),
                  ),
            ),
            Text('add to your jar')
          ],
        ));
  }
}
