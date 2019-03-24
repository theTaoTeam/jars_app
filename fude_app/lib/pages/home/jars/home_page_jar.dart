import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fude/widgets/page_transformer/page_transformer.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/jar.dart';

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
          jar['title'],
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  color: Color.fromRGBO(236, 240, 241, 1),
                  onPressed: () {
                    print('jar pressed, ${jar.documentID}');
                    model.getJarBySelectedId(jar.documentID);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return JarPage();
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Color.fromRGBO(236, 240, 241, 1),
                  onPressed: () => print('favorite jar pressed'),
                ),
              ],
            ),
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
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var image = Image.network(
      jar['image'] != null
          ? jar['image']
          : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
      fit: BoxFit.cover,
      alignment: FractionalOffset(
        0.5 + (pageVisibility.pagePosition / 3),
        0.5,
      ),
    );

    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: [
            Color.fromRGBO(33, 38, 43, 0.7),
            Color.fromRGBO(33, 38, 43, 1),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 5.0,
      ),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageOverlayGradient,
            image,
            _buildTextContainer(context),
          ],
        ),
      ),
    );
  }
}
