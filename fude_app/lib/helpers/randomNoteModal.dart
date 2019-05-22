import 'package:flutter/material.dart';
import 'package:fude/models/idea.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/notes/note.dart';
import 'package:fude/pages/notes/notes_add.dart';

void showRandomNote(
    BuildContext context, Idea randomNote, MainModel model, String category) {
  final double height = MediaQuery.of(context).size.height;
  final double width = MediaQuery.of(context).size.width;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Theme(
        data: Theme.of(context)
            .copyWith(dialogBackgroundColor: Theme.of(context).primaryColor),
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: EdgeInsets.all(2.5),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              height: randomNote != null ? height * 0.35 : height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // dialog centre
                  randomNote != null
                      ? Expanded(
                          flex: 3,
                          child: Container(
                            height: height,
                            width: width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: randomNote.image != null
                                      ? randomNote.image.runtimeType != String
                                          ? Image.file(
                                              randomNote.image,
                                              fit: BoxFit.cover,
                                              alignment: FractionalOffset(
                                                0.5,
                                                0.5,
                                              ),
                                            )
                                          : NetworkImage(randomNote.image)
                                      : 'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .secondaryHeaderColor
                                          .withOpacity(0.3),
                                      BlendMode.dstATop)),
                            ),
                            child: Center(
                              child: Text(
                                randomNote.title.toUpperCase(),
                                style: Theme.of(context).textTheme.subtitle,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  // dialog top
                  randomNote == null
                      ? Expanded(
                          child: Center(
                            child: Text(
                              category == 'ALL'
                                  ? "You still need to add some ideas to this jar!"
                                  : "You don't have any ideas in this category yet!",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor ==
                                        Color.fromRGBO(40, 40, 40, 1)
                                    ? Color.fromRGBO(242, 242, 242, 1)
                                    : Color.fromRGBO(40, 40, 40, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        )
                      : Container(),

                  // dialog bottom
                  randomNote != null
                      ? Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              // flex: 4,
                              child: Container(
                                // width: width,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                child: FlatButton(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    child: Text(
                                      'OPEN',
                                      style:
                                          Theme.of(context).textTheme.headline,
                                      textAlign: TextAlign.center,
                                    ),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          curve: Curves.linear,
                                          type: PageTransitionType.downToUp,
                                          child: NotePage(
                                            idea: randomNote,
                                            isRandom: true,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        )
                      : Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              // flex: 4,
                              child: Container(
                                // width: width,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                child: FlatButton(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  child: Text(
                                    'ADD IDEA',
                                    style: Theme.of(context).textTheme.headline,
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () => Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          curve: Curves.linear,
                                          type: PageTransitionType.downToUp,
                                          child: AddNotePage(
                                              fromJarScreen: true,
                                              categories: model.selectedJar
                                                  .data['categories']),
                                        ),
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
