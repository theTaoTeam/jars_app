import 'package:flutter/material.dart';

ThemeData buildAppThemeData(bool darkTheme) {
  return ThemeData(
    fontFamily: 'Muli',
    primaryColor: !darkTheme
        ? Color.fromRGBO(242, 242, 242, 1)
        : Color.fromRGBO(40, 40, 40, 1),
    secondaryHeaderColor: darkTheme
        ? Color.fromRGBO(242, 242, 242, 1)
        : Color.fromRGBO(40, 40, 40, 1),
    accentColor: darkTheme
        ? Color.fromRGBO(242, 242, 242, 1)
        : Color.fromRGBO(40, 40, 40, 1),
    textTheme: TextTheme(
      title: TextStyle(
        color: !darkTheme
            ? Color.fromRGBO(40, 40, 40, 1)
            : Color.fromRGBO(242, 242, 242, 1),
        fontWeight: FontWeight.w400,
        fontSize: 24,
        letterSpacing: 8,
      ),
      subhead: TextStyle(
        color: !darkTheme
            ? Color.fromRGBO(242, 242, 242, 1)
            : Color.fromRGBO(40, 40, 40, 1),
        fontWeight: FontWeight.w500,
        fontSize: 22,
        letterSpacing: 3,
      ),
      subtitle: TextStyle(
        color: darkTheme
            ? Color.fromRGBO(242, 242, 242, 1)
            : Color.fromRGBO(40, 40, 40, 1),
        fontWeight: FontWeight.bold,
        fontSize: 20,
        letterSpacing: 10,
      ),
      headline: TextStyle(
        color: !darkTheme
            ? Color.fromRGBO(242, 242, 242, 1)
            : Color.fromRGBO(40, 40, 40, 1),
        fontWeight: FontWeight.bold,
        fontSize: 18,
        letterSpacing: 3,
      ),
      caption: TextStyle(
        color: !darkTheme
            ? Color.fromRGBO(242, 242, 242, 1)
            : Color.fromRGBO(40, 40, 40, 1),
        fontSize: 14,
        letterSpacing: 2,
      ),
    ),
    iconTheme: IconThemeData(
        color: !darkTheme
            ? Color.fromRGBO(40, 40, 40, 1)
            : Color.fromRGBO(242, 242, 242, 1),
        size: 40),
    cardColor: !darkTheme
        ? Color.fromRGBO(40, 40, 40, 1)
        : Color.fromRGBO(242, 242, 242, 1),
  );
}

NetworkImage logoInStorage() {
  return NetworkImage(
      'https://firebasestorage.googleapis.com/v0/b/fude-app.appspot.com/o/Scoot-01.png?alt=media&token=53fc26de-7c61-4076-a0cb-f75487779604',
      scale: 0.1);
}
