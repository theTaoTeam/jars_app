import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/pages/notes/notes_card.dart';
import 'package:fude/pages/notes/notes_add.dart';
import 'package:fude/pages/jars/jar.dart';
import 'package:fude/scoped-models/main.dart';
import 'package:fude/models/idea.dart';
import 'package:fude/helpers/snackBar.dart';

class JarNotes extends StatefulWidget {
  final MainModel model;

  JarNotes({@required this.model});

  @override
  State<StatefulWidget> createState() {
    return _JarNotesState();
  }
}

class _JarNotesState extends State<JarNotes> {
  StreamSubscription<ConnectivityResult> subscription;
  final GlobalKey<ScaffoldState> sScaffoldState = GlobalKey<ScaffoldState>();
  bool isFavorite = false;

  @override
  void initState() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showSnackBar(sScaffoldState);
        print('No Connection: $result');
      }
    });
    super.initState();
  }

  void toggleFavoriteFilter() {
    setState(() {
      isFavorite = !isFavorite;
      widget.model.fetchFavoriteJarIdeas();
    });
  }

  void toggleFavoriteStatus(Idea idea, int index) {
    setState(() {
      widget.model.toggleFavoriteStatus(idea, index);
    });
  }

  _buildNoteListItem(BuildContext context, Idea idea, int index) {
    return NotesCard(
        idea: idea,
        index: index,
        toggleFavoriteStatus: toggleFavoriteStatus,
        model: widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: sScaffoldState,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () => Navigator.pushReplacement(
                context,
                PageTransition(
                  curve: Curves.linear,
                  type: PageTransitionType.fade,
                  child: JarPage(model: widget.model),
                ),
              ),
          iconSize: Theme.of(context).iconTheme.size,
          color: Theme.of(context).iconTheme.color,
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(
              right: width * 0.04,
            ),
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              icon: Icon(Icons.add),
              iconSize: Theme.of(context).iconTheme.size,
              color: Theme.of(context).iconTheme.color,
              onPressed: () => Navigator.pushReplacement(
                    context,
                    PageTransition(
                      curve: Curves.linear,
                      type: PageTransitionType.downToUp,
                      child: AddNotePage(
                          fromJarScreen: false,
                          categories:
                              widget.model.selectedJar.data['categories']),
                    ),
                  ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
        child: widget.model.isLoading
            ? Center(child: CircularProgressIndicator())
            : widget.model.jarIdeas.length > 0
                ? Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    width * 0.05, 0, 0, height * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      !isFavorite
                                          ? 'ALL IDEAS'
                                          : 'FAVORITE IDEAS',
                                      style: TextStyle(
                                        color: Color.fromRGBO(131, 129, 129, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        letterSpacing: 5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Flexible(
                        child: Container(
                          height: height * 0.72,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            // reverse: false,
                            scrollDirection: Axis.vertical,
                            itemCount: !isFavorite
                                ? widget.model.jarIdeas.length
                                : widget.model.favIdeas.length,
                            itemBuilder: (BuildContext context, int index) {
                              return !isFavorite
                                  ? _buildNoteListItem(context,
                                      widget.model.jarIdeas[index], index)
                                  : _buildNoteListItem(context,
                                      widget.model.favIdeas[index], index);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              0, 0, width * 0.04, width * 0.05),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: isFavorite
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            iconSize: 38,
                            color: Theme.of(context).iconTheme.color,
                            onPressed: () => toggleFavoriteFilter(),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: height * .3,
                      ),
                      Center(
                        child: Text(
                          isFavorite
                              ? 'NO FAVORITES'
                              : 'ADD AN IDEA TO GET STARTED',
                          style: Theme.of(context).textTheme.subtitle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                0, 0, width * 0.04, width * 0.05),
                            child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: isFavorite
                                  ? Icon(Icons.favorite)
                                  : Icon(Icons.favorite_border),
                              iconSize: 38,
                              color: Theme.of(context).iconTheme.color,
                              onPressed: () => toggleFavoriteFilter(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
