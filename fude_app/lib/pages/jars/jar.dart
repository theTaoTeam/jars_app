import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar_notes.dart';
import 'package:fude/pages/notes/note.dart';
import 'package:fude/pages/jars/category_card.dart';
import 'package:fude/widgets/page_transformer/page_transformer.dart';

class JarPage extends StatefulWidget {
  final MainModel model;

  JarPage({this.model});

  @override
  State<StatefulWidget> createState() {
    return _JarPageState();
  }
}

class _JarPageState extends State<JarPage> {
  bool isFavorite = false;
  bool _swiperVisible = false;
  String selectedCategory;
  PageController controller;

  @override
  void initState() {
    selectedCategory = widget.model.selectedJar.data['categories'][0];
    Timer(Duration(milliseconds: 500), fadeInstructions);
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

  void toggleFavoriteFilter() {
    setState(() {
      isFavorite = !isFavorite;
    });
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
    try {
      notes = await model.fetchJarNotesByCategory(category);
    } catch (e) {
      print(e);
    }
    randomNote = notes[_random.nextInt(notes.length)];
    Navigator.pushReplacement(
      context,
      PageTransition(
        curve: Curves.linear,
        type: PageTransitionType.downToUp,
        child: NotePage(note: randomNote, isRandom: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var image = Image.network(
      widget.model.selectedJar.data['image'] != null
          ? widget.model.selectedJar.data['image']
          : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
      fit: BoxFit.cover,
    );
    var imageOverlayGradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Color.fromRGBO(33, 38, 43, 0.1),
              Color.fromRGBO(33, 38, 43, 0.5),
            ]),
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
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                Color.fromRGBO(235, 237, 238, 1),
                Color.fromRGBO(253, 251, 251, 1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: model.selectedJar.data['title'],
                      child: Container(
                        height: height,
                        child: Material(
                          elevation: 1.0,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              imageOverlayGradient,
                              Container(
                                padding: EdgeInsets.only(top: 40),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    AnimatedOpacity(
                                      opacity: _swiperVisible ? 1.0 : 0.0,
                                      duration: Duration(milliseconds: 1000),
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.white,
                                          ),
                                          iconSize: 40,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: width / 3,
                                right: width / 3,
                                bottom: 700,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      model.selectedJar.data['title']
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                      textAlign:TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              //SWIPER
                              AnimatedOpacity(
                                opacity: _swiperVisible ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  width: width,
                                  height: height * 0.4,
                                  child: PageTransformer(
                                    pageViewBuilder:
                                        (context, visibilityResolver) {
                                      return PageView.builder(
                                        reverse: true,
                                        controller: PageController(
                                            viewportFraction: 0.7,
                                            initialPage: model.selectedJar
                                                .data['categories'].length),
                                        itemCount: model.selectedJar
                                            .data['categories'].length,
                                        itemBuilder: (context, index) {
                                          final PageVisibility pageVisibility =
                                              visibilityResolver
                                                  .resolvePageVisibility(index);

                                          return GestureDetector(
                                            onTap: () {},
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

              // Expanded(
              //   child: Align(
              //     alignment: Alignment.bottomLeft,
              //     child: AnimatedOpacity(
              //       opacity: _swiperVisible ? 1.0 : 0.0,
              //       duration: Duration(milliseconds: 2000),
              //       child: Container(
              //         height: height * 0.1,
              //         padding: EdgeInsets.fromLTRB(20, 0, 0, 25),
              //         child: GestureDetector(
              //           onTap: () => Navigator.push(
              //                 context,
              //                 PageTransition(
              //                   curve: Curves.linear,
              //                   type: PageTransitionType.rightToLeftWithFade,
              //                   child: JarNotes(model: model),
              //                 ),
              //               ),
              //           child: Row(
              //             children: <Widget>[
              //               Text(
              //                 'ALL IDEAS',
              //                 style:
              //                     TextStyle(color: Colors.black, fontSize: 16),
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios,
              //                 color: Colors.black,
              //                 size: 16,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      );
    });
  }
}
