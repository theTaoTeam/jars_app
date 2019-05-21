import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:ui';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar_notes.dart';
import 'package:fude/pages/jars/category_card.dart';
import 'package:fude/pages/home/home.dart';
import 'package:fude/helpers/randomNoteModal.dart';
import 'package:fude/pages/notes/notes_add.dart';

class JarPage extends StatefulWidget {
  final MainModel model;

  JarPage({
    @required this.model,
  });

  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<JarPage> {
  bool _swiperVisible = false;

  @override
  void initState() {
    widget.model.resetIsLoading();
    fadeInstructions();
    super.initState();
  }

  void fadeInstructions() {
    setState(() {
      _swiperVisible = true;
    });
  }

  void _pullRandomNote(MainModel model, String category) async {
    final _random = Random();
    List<DocumentSnapshot> notes = [];
    DocumentSnapshot randomNote;
    print('CATEGORY: $category');
    try {
      notes = await model.fetchJarNotesByCategory(category);
    } catch (e) {
      print(e);
    }
    if (notes != null && notes.length != 0) {
      print("notes !== NULL: $notes");
      randomNote = notes[_random.nextInt(notes.length)];
    }
    print("notes: $notes");

    showRandomNote(context, randomNote, model, category);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var image = Positioned(
      top: 0,
      left: width * 0.01,
      right: width * 0.01,
      height: height * 0.5,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.model.selectedJar.data['image'] != null
                ? NetworkImage(widget.model.selectedJar.data['image'])
                : AssetImage('assets/logo.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );

    var imageOverlayGradient = BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Container(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: !widget.model.darkTheme
                  ? [
                      Color.fromRGBO(242, 242, 242, 0.3),
                      Color.fromRGBO(242, 242, 242, 1),
                    ]
                  : [
                      Color.fromRGBO(40, 40, 40, 0.3),
                      Color.fromRGBO(40, 40, 40, 1),
                    ],
            ),
          ),
        ),
      ),
    );

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).secondaryHeaderColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width,
                height: height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: height,
                      width: width,
                      child: Material(
                        elevation: 0,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            image,
                            imageOverlayGradient,
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.fromLTRB(
                                  width * 0.02, height * 0.06, width * 0.03, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  AnimatedOpacity(
                                    opacity: _swiperVisible ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 1000),
                                    child: Container(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          iconSize: 40,
                                          onPressed: () {
                                            _swiperVisible = false;
                                            Navigator.pop(
                                              context,
                                              PageTransition(
                                                curve: Curves.linear,
                                                type:
                                                    PageTransitionType.upToDown,
                                                child: HomePage(
                                                    model: widget.model),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: _swiperVisible ? 1.0 : 0.0,
                                    duration: Duration(milliseconds: 1000),
                                    child: Container(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.filter_list,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          iconSize: 39,
                                          onPressed: () {
                                            _swiperVisible = false;
                                            Navigator.pushReplacement(
                                              context,
                                              PageTransition(
                                                curve: Curves.linear,
                                                type: PageTransitionType
                                                    .rightToLeftWithFade,
                                                child: JarNotes(model: model),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: height * 0.07,
                              left: width * 0.05,
                              // right: width * 0.2,
                              child: AnimatedOpacity(
                                opacity: _swiperVisible ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 1000),
                                child: Container(
                                  width: width * 0.7,
                                  child: Text(
                                    model.selectedJar.data['title']
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.title,
                                    textAlign: TextAlign.left,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: height * 0.24,
                              left: width * 0.07,
                              right: width * 0.07,
                              child: AnimatedOpacity(
                                  opacity: _swiperVisible ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 1000),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'TAP A CATEGORY FOR A NEW IDEA',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          letterSpacing: 2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Text(
                                        '- OR -',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          letterSpacing: 2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                      Text(
                                        'TAP THE + TO ADD AN IDEA',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          letterSpacing: 1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  )),
                            ),
                            //SWIPER
                            Positioned(
                              top: height * 0.45,
                              // left: width * 0.47,
                              width: width,
                              height: height * 0.34,
                              child: AnimatedOpacity(
                                opacity: _swiperVisible ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: PageView.builder(
                                  reverse: false,
                                  pageSnapping: true,
                                  scrollDirection: Axis.horizontal,
                                  controller: PageController(
                                      viewportFraction: .6, initialPage: 0),
                                  itemCount: model
                                      .selectedJar.data['categories'].length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () => _pullRandomNote(
                                          model,
                                          model.selectedJar.data['categories']
                                              [index]),
                                      child: CategoryCard(
                                        model: widget.model,
                                        category: model.selectedJar
                                            .data['categories'][index],
                                        index: index,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                    0, 0, 0, height * 0.051),
                                padding: EdgeInsets.only(right: width * 0.03),
                                child: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: Icon(Icons.add),
                                  iconSize: 39,
                                  color: Theme.of(context).secondaryHeaderColor,
                                  onPressed: () => Navigator.push(
                                        context,
                                        PageTransition(
                                          curve: Curves.linear,
                                          type: PageTransitionType.downToUp,
                                          child: AddNotePage(
                                            fromJarScreen: true,
                                            categories: model
                                                .selectedJar.data['categories'],
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
