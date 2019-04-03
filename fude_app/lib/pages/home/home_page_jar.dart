import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/widgets/page_transformer/page_transformer.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar_edit.dart';
import 'package:fude/pages/jars/jar_add.dart';

class HomePageJar extends StatelessWidget {
  HomePageJar({
    @required this.model,
    @required this.jar,
    @required this.pageVisibility,
  });

  final DocumentSnapshot jar;
  final MainModel model;
  final PageVisibility pageVisibility;

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    final double xTranslation = pageVisibility.pagePosition * translationFactor;

    return Opacity(
      opacity: pageVisibility.visibleFraction,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          xTranslation,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    // var categoryText = _applyTextEffects(
    //   translationFactor: 300.0,
    //   child: Text(
    //     'asdf',
    //     style: textTheme.caption.copyWith(
    //       color: Colors.white70,
    //       fontWeight: FontWeight.bold,
    //       letterSpacing: 2.0,
    //       fontSize: 14.0,
    //     ),
    //     textAlign: TextAlign.center,
    //   ),
    // );

    var titleText = _applyTextEffects(
      translationFactor: 200.0,
      child: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          jar['title'].toUpperCase(),
          style: textTheme.title
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );

    return Positioned(
        top: 20,
        bottom: 56.0,
        left: 28.0,
        right: 28.0,
        child: jar['title'] != 'Add Jar'
            ? Column(
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
                      Expanded(child: Container()),
                      IconButton(
                        padding: EdgeInsets.fromLTRB(15, 12, 0, 0),
                        icon: Icon(Icons.edit),
                        color: Color.fromRGBO(236, 240, 241, 1),
                        onPressed: () {
                          print('jar pressed, ${jar.documentID}');
                          model.getJarBySelectedId(jar.documentID);
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.downToUp,
                              child: EditJarPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 82,
                    color: Color.fromRGBO(236, 240, 241, 1),
                    onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.linear,
                            type: PageTransitionType.downToUp,
                            child: AddJarPage(),
                          ),
                        ),
                  ),
                  Text(
                    jar['title'].toUpperCase(),
                    style: TextStyle(
                      color: Color.fromRGBO(236, 240, 241, 1),
                      fontSize: 18,
                    ),
                  ),
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    var image = jar['title'] != 'Add Jar'
        ? ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              jar['image'] != null
                  ? jar['image']
                  : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
              fit: BoxFit.cover,
              alignment: FractionalOffset(
                0.5 + (pageVisibility.pagePosition / 3),
                0.5,
              ),
            ),
          )
        : Container();

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: jar['title'] != 'Add Jar'
              ? [
                  Color.fromRGBO(33, 38, 43, 0.1),
                  Color.fromRGBO(33, 38, 43, 0.5),
                ]
              : [
                  Color.fromRGBO(137, 247, 254, 1),
                  Color.fromRGBO(102, 166, 255, 1),
                ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 26.0,
        horizontal: 10.0,
      ),
      child: Hero(
        tag: jar['title'],
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              image,
              imageOverlayGradient,
              _buildTextContainer(context),
            ],
          ),
        ),
      ),
    );
  }
}
