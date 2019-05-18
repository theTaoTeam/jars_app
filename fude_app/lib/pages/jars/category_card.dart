import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:ui';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/notes/notes_add.dart';
import 'package:fude/scoped-models/main.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({
    @required this.model,
    @required this.category,
    @required this.index,
  });

  final String category;
  final int index;
  final MainModel model;

  _buildTextContainer(BuildContext context) {
    var titleText = Expanded(
      child: Text(
        category.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subhead,
        textAlign: TextAlign.left,
      ),
    );

    return Positioned(
      top: 20,
      bottom: 20.0,
      left: 28.0,
      right: 28.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              titleText,
              // Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  _buildIconContainer(BuildContext context) {
    var icon = Expanded(
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(Icons.add),
        iconSize: 28,
        color: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushReplacement(
              context,
              PageTransition(
                curve: Curves.linear,
                type: PageTransitionType.downToUp,
                child: AddNotePage(
                    fromJarScreen: true,
                    categories: model.selectedJar.data['categories'],
                    category: category),
              ),
            ),
      ),
    );

    return Positioned(
      top: 165,
      bottom: 20.0,
      left: 0.0,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
          icon,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    var imageOverlayGradient = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: !model.darkTheme
                ? [
                    Color.fromRGBO(40, 40, 40, 0.6),
                    Color.fromRGBO(40, 40, 40, 1),
                  ]
                : [
                    Color.fromRGBO(242, 242, 242, 0.1),
                    Color.fromRGBO(242, 242, 242, 1),
                  ]),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 10.0,
      ),
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageOverlayGradient,
            // _applyTextEffects(
            //   translationFactor: 50.0,
            //   child: Center(
            //     child: ,
            //   ),
            // ),
            _buildTextContainer(context),
            _buildIconContainer(context)
          ],
        ),
      ),
    );
  }
}
