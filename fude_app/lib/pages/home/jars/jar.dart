import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/helpers/design_helpers.dart';
import 'package:fude/pages/home/jars/jar_notes.dart';
import 'package:fude/pages/home/notes/note.dart';

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
  bool _instructionVisible = true;
  bool _categorySelectVisible = false;
  String selectedCategory;

  void toggleFavoriteFilter() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    selectedCategory = widget.model.selectedJar.data['categories'][0];
    Timer(Duration(seconds: 3), fadeInstructions);
    super.initState();
  }

  void fadeInstructions() {
    setState(() {
      _instructionVisible = false;
      _categorySelectVisible = true;
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
        type: PageTransitionType.rightToLeftWithFade,
        child: NotePage(note: randomNote, isRandom: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.only(right: 25),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(Icons.close),
              color: Color.fromRGBO(236, 240, 241, 1),
              iconSize: 34,
              onPressed: () => Navigator.pop(context),
            )
          ],
          backgroundColor: Color.fromRGBO(33, 38, 43, 1),
          elevation: 0,
          title: GestureDetector(
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Icon%20Dark.png?alt=media&token=717822bd-3e49-46e7-b7d8-1b432afd3e50',
              height: height * 0.2,
              width: width * 0.2,
            ),
            onTap: () => print('invert theme pressed'),
          ),
        ),
        body: Container(
          height: height,
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(33, 38, 43, 0.3), BlendMode.dstIn),
                image: model.selectedJar.data['image'] != null
                    ? NetworkImage(model.selectedJar.data['image'])
                    : logoInStorage()),
            gradient: LinearGradient(
              begin: FractionalOffset.bottomCenter,
              end: FractionalOffset.topCenter,
              colors: [
                Color.fromRGBO(33, 38, 43, 0.7),
                Color.fromRGBO(33, 38, 43, 1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _instructionVisible
                  ? AnimatedOpacity(
                      opacity: _instructionVisible ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Container(
                        padding: EdgeInsets.only(top: height * 0.29),
                        height: height / 2,
                        child: Text(
                          'SELECT CATEGORY THEN TAP TO PULL A NEW IDEA',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : AnimatedOpacity(
                      opacity: _instructionVisible ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Container(),
                    ),
              _categorySelectVisible
                  ? AnimatedOpacity(
                      opacity: _categorySelectVisible ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: height / 2,
                            width: width,
                            child: Swiper(
                              itemWidth: width,
                              loop: false,
                              itemCount:
                                  model.selectedJar.data['categories'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Center(
                                    child: Text(
                                  model.selectedJar.data['categories'][index]
                                      .toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ));
                              },
                              control: SwiperControl(
                                  size: 25,
                                  color: Colors.white,
                                  disableColor: Colors.transparent),
                              onIndexChanged: (index) {
                                setState(() {
                                  selectedCategory = model
                                      .selectedJar.data['categories'][index];
                                });
                              },
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              child: Text('PULL FROM YOUR JAR'),
                              onPressed: () {
                                // print('tapped pull idea');
                                _pullRandomNote(model, selectedCategory);
                              },
                            ),
                          ),
                        ],
                      ))
                  : AnimatedOpacity(
                      opacity: _categorySelectVisible ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Container(),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Your ${model.selectedJar.data['title']} ideas'
                        .toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_upward,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.push(
                          context,
                          PageTransition(
                            curve: Curves.linear,
                            type: PageTransitionType.downToUp,
                            child: JarNotes(model: model),
                          ),
                        ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
