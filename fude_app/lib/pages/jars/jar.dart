import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar_notes.dart';
import 'package:fude/pages/jars/category_card.dart';
import 'package:fude/pages/home/home.dart';
import 'package:fude/widgets/page_transformer/page_transformer.dart';
import 'package:fude/helpers/randomNoteModal.dart';

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
  String selectedCategory;
  PageController controller;

  @override
  void initState() {
    print('rendering jarpage');
    selectedCategory = widget.model.selectedJar.data['categories'][0];
    Timer(Duration(seconds: 0), fadeInstructions);
    controller = PageController(
      keepPage: false,
      viewportFraction: .85,
    );
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
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
            image: NetworkImage(
              widget.model.selectedJar.data['image'] != null
                  ? widget.model.selectedJar.data['image']
                  : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
              scale: 0.5,
            ),
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
                      Color.fromRGBO(242, 242, 242, 0.5),
                      Color.fromRGBO(40, 40, 40, 0.5),
                    ]
                  : [
                      Color.fromRGBO(40, 40, 40, 0.5),
                      Color.fromRGBO(242, 242, 242, 1),
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
                    Hero(
                      tag: model.selectedJar.data['title'],
                      child: Container(
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
                                    width * 0.02, height * 0.05, 0, 0),
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
                                              Navigator.push(
                                                context,
                                                PageTransition(
                                                  curve: Curves.linear,
                                                  type: PageTransitionType
                                                      .upToDown,
                                                  child: HomePage(model: model),
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
                                top: height * 0.24,
                                left: width * 0.07,
                                right: width * 0.07,
                                child: AnimatedOpacity(
                                  opacity: _swiperVisible ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 1000),
                                  child: Text(
                                    model.selectedJar.data['title']
                                        .toUpperCase(),
                                    overflow: TextOverflow.clip,
                                    style: Theme.of(context).textTheme.title,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: height * 0.46,
                                left: width * 0.07,
                                right: width * 0.07,
                                child: AnimatedOpacity(
                                  opacity: _swiperVisible ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 1000),
                                  child: Text(
                                    'SELECT CATEGORY',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              //SWIPER
                              Positioned(
                                top: height * 0.53,
                                // left: width * 0.47,
                                width: width,
                                height: height * 0.34,
                                child: AnimatedOpacity(
                                  opacity: _swiperVisible ? 1.0 : 0.0,
                                  duration: Duration(milliseconds: 500),
                                  child: PageTransformer(
                                    pageViewBuilder:
                                        (context, visibilityResolver) {
                                      return PageView.builder(
                                        reverse: true,
                                        pageSnapping: true,
                                        scrollDirection: Axis.horizontal,
                                        controller: PageController(
                                            viewportFraction: .62,
                                            initialPage: model.selectedJar
                                                .data['categories'].length),
                                        itemCount: model.selectedJar
                                            .data['categories'].length,
                                        itemBuilder: (context, index) {
                                          final PageVisibility pageVisibility =
                                              visibilityResolver
                                                  .resolvePageVisibility(index);
                                          return GestureDetector(
                                            onTap: () => _pullRandomNote(
                                                model,
                                                model.selectedJar
                                                    .data['categories'][index]),
                                            child: CategoryCard(
                                              model: widget.model,
                                              category: model.selectedJar
                                                  .data['categories'][index],
                                              index: index,
                                              pageVisibility: pageVisibility,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
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
