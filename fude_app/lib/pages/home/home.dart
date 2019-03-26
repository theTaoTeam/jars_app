import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/jar.dart';
import 'package:fude/pages/home/jars/home_page_jar.dart';
import 'package:fude/widgets/page_transformer/page_transformer.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage({this.model});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  PageController controller;
  int currentpage = 0;
  double animatedHeight = 100;
  double animatedWidth = 100;
  @override
  initState() {
    super.initState();
    controller = PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: .85,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: width,
        child: StreamBuilder(
            stream: Firestore.instance.collection('jars').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container(
                  margin: EdgeInsets.only(top: height / 2),
                  height: height * 1.25,
                  child: PageTransformer(
                    pageViewBuilder: (context, visibilityResolver) {
                      return PageView.builder(
                        controller: PageController(viewportFraction: 0.85),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          final PageVisibility pageVisibility =
                              visibilityResolver.resolvePageVisibility(index);

                          return GestureDetector(
                            onTap: () {
                              widget.model.getJarBySelectedId(
                                  snapshot.data.documents[index].documentID);
                              Navigator.push(
                                context,
                                PageTransition(
                                  curve: Curves.linear,
                                  type: PageTransitionType.fade,
                                  child:
                                      JarPage(),
                                ),
                              );
                            },
                            child: HomePageJar(
                              model: widget.model,
                              jar: snapshot.data.documents[index],
                              pageVisibility: pageVisibility,
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            }),
      ),
    );
  }
}
