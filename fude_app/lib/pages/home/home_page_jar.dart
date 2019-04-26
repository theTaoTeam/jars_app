import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/widgets/page_transformer/page_transformer.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar_edit.dart';
import 'package:fude/pages/jars/jar_add.dart';

class HomePageJar extends StatelessWidget {
  final DocumentSnapshot jar;
  final MainModel model;
  final PageVisibility pageVisibility;
  final String title;

  HomePageJar(
      {@required this.model, this.jar, this.pageVisibility, this.title});

  Widget _applyTextEffects({
    @required double translationFactor,
    @required Widget child,
  }) {
    return Opacity(
      opacity: 1,
      child: Transform(
        alignment: FractionalOffset.topLeft,
        transform: Matrix4.translationValues(
          0.0,
          0.0,
          0.0,
        ),
        child: child,
      ),
    );
  }

  _buildTextContainer(BuildContext context) {
    var titleText = _applyTextEffects(
      translationFactor: 100.0,
      child: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          title == null ? jar['title'].toUpperCase() : 'ADD JAR',
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
          textAlign: TextAlign.left,
        ),
      ),
    );

    return Positioned(
        top: 20,
        bottom: 56.0,
        left: 28.0,
        right: 28.0,
        child: title == null
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
                        iconSize: 26,
                        color: Theme.of(context).textTheme.subhead.color,
                        onPressed: () {
                          print('jar pressed, ${jar['id']}');
                          model.getJarBySelectedId(jar['id']);
                          Navigator.push(
                            context,
                            PageTransition(
                              curve: Curves.linear,
                              type: PageTransitionType.downToUp,
                              child: EditJarPage(model: model),
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
                    iconSize: 70,
                    color: model.darkTheme
                        ? Color.fromRGBO(40, 40, 40, 1)
                        : Color.fromRGBO(242, 242, 242, 1),
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
                    title == null ? jar['title'].toUpperCase() : 'ADD JAR',
                    style: TextStyle(
                      color: model.darkTheme
                          ? Color.fromRGBO(40, 40, 40, 1)
                          : Color.fromRGBO(242, 242, 242, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 5,
                    ),
                  ),
                ],
              ));
  }

  @override
  Widget build(BuildContext context) {
    var image = title == null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.network(
              jar['image'] != null
                  ? jar['image']
                  : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
              fit: BoxFit.cover,
              alignment: FractionalOffset(
                0.5,
                0.5,
              ),
            ),
          )
        : Container();

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        color: title != null ? Theme.of(context).secondaryHeaderColor : null,
        gradient: title == null
            ? LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: title == null
                    ? !model.darkTheme
                        ? [
                            Color.fromRGBO(242, 242, 242, 0),
                            Color.fromRGBO(40, 40, 40, 1),
                          ]
                        : [
                            Color.fromRGBO(40, 40, 40, 0),
                            Color.fromRGBO(242, 242, 242, 1),
                          ]
                    : null)
            : null,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 26.0,
        horizontal: 10.0,
      ),
      child: Material(
        elevation: model.darkTheme ? 4.0 : 8,
        shadowColor: Theme.of(context).secondaryHeaderColor,
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
    );
  }
}
