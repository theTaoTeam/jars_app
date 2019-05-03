import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/jars/jar.dart';
import 'package:fude/pages/home/home_page_jar.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage({this.model});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    widget.model.fetchAllUserJars(widget.model.currUserEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // print('LIST in BUILD ${widget.model.usersJars[0].runtimeType}');

    return Scaffold(
      appBar: AppBar(
        title: Container(
          margin: EdgeInsets.only(left: width * 0.7),
          child: GestureDetector(
            child: Text(
              'logout',
              style: TextStyle(
                color: Theme.of(context).primaryColor ==
                        Color.fromRGBO(242, 242, 242, 1)
                    ? Color.fromRGBO(40, 40, 40, 1)
                    : Color.fromRGBO(242, 242, 242, 1),
                // fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
            onTap: () => widget.model.logout(),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColor,
        highlightElevation: 0,
        onPressed: () => widget.model.invertTheme(),
        child:
            Theme.of(context).primaryColor == Color.fromRGBO(242, 242, 242, 1)
                ? Image.asset(
                    'assets/IconDark.png',
                    height: height * 0.2,
                    width: width * 0.2,
                  )
                : Image.asset(
                    'assets/IconLight.png',
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
            widget.model.usersJars.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    margin: EdgeInsets.fromLTRB(0, height * 0.1, 0, 0),
                    width: width,
                    height: height * 0.55,
                    child: PageView.builder(
                        reverse: false,
                        pageSnapping: true,
                        controller: PageController(
                            keepPage: false,
                            viewportFraction: 0.88,
                            initialPage: 0),
                        itemCount: widget.model.usersJars.length,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? HomePageJar(
                                  model: widget.model, title: 'Add Jar')
                              : GestureDetector(
                                  onTap: () {
                                    widget.model.getJarBySelectedId(widget
                                        .model.usersJars[index].documentID);
                                    Timer(Duration(milliseconds: 500), () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          curve: Curves.linear,
                                          type: PageTransitionType.downToUp,
                                          child: JarPage(model: widget.model),
                                        ),
                                      );
                                    });
                                  },
                                  child: HomePageJar(
                                      model: widget.model,
                                      jar: widget.model.usersJars[index],
                                      title: null),
                                );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}
