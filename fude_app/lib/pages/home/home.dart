import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar.dart';
import 'package:fude/pages/home/home_page_jar.dart';
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
  @override
  initState() {
    super.initState();
    controller = PageController(
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
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        leading: Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColor,
        highlightElevation: 0,
        onPressed: () => widget.model.invertTheme(),
        child: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Icon%20Dark.png?alt=media&token=717822bd-3e49-46e7-b7d8-1b432afd3e50',
          height: height * 0.2,
          width: width * 0.2,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        elevation: 0,
        child: Container(height: 20),
      ),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance.collection('jars').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    print('no jars');
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, height * 0.1, 0, 0),
                      width: width,
                      height: height * 0.55,
                      child: PageTransformer(
                        pageViewBuilder: (context, visibilityResolver) {
                          return PageView.builder(
                            reverse: true,
                            pageSnapping: true,
                            controller: PageController(
                                viewportFraction: 0.88,
                                initialPage: snapshot.data.documents.length),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) {
                              final PageVisibility pageVisibility =
                                  visibilityResolver
                                      .resolvePageVisibility(index);

                              return snapshot.data.documents[index]['title'] !=
                                      'Add Jar'
                                  ? GestureDetector(
                                      onTap: () {
                                        widget.model.getJarBySelectedId(snapshot
                                            .data.documents[index].documentID);
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            curve: Curves.linear,
                                            type: PageTransitionType.fade,
                                            child: JarPage(model: widget.model),
                                          ),
                                        );
                                      },
                                      child: HomePageJar(
                                        model: widget.model,
                                        jar: snapshot.data.documents[index],
                                        pageVisibility: pageVisibility,
                                      ),
                                    )
                                  : HomePageJar(
                                      model: widget.model,
                                      jar: snapshot.data.documents[index],
                                      pageVisibility: pageVisibility,
                                    );
                            },
                          );
                        },
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
