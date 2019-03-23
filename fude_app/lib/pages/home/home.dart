import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/jar_card.dart';
import 'package:fude/pages/home/jars/jar.dart';

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

  builder(int index, double height, double width,
      {DocumentSnapshot jar, String jarTitle, String jarID, String jarImage}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 450,
            width: Curves.easeOut.transform(value) * 400,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          widget.model.getJarBySelectedId(jar.documentID);
          Navigator.push(
            context,
            PageTransition(
              curve: Curves.linear,
              type: PageTransitionType.fade,
              child: JarPage(),
            ),
          );
        },
        child: JarCard(
          model: widget.model,
          jarTitle: jarTitle,
          jarID: jarID,
          jarImage: jarImage,
        ),
      ),
    );
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
                return PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentpage = value;
                    });
                  },
                  controller: controller,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => builder(
                        index,
                        height,
                        width,
                        jar: snapshot.data.documents[index],
                        jarTitle: snapshot.data.documents[index]['title'],
                        jarID: snapshot.data.documents[index].documentID,
                        jarImage: snapshot.data.documents[index]['image'],
                      ),
                  scrollDirection: Axis.horizontal,
                );
              }
            }),
      ),
    );
  }
}
