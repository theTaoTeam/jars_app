import 'package:flutter/material.dart';

import 'package:fude/scoped-models/main.dart';
import 'package:fude/pages/home/jars/all-jars/all_jars.dart';
import 'package:fude/pages/home/main-banner/main_banner.dart';
import 'package:fude/helpers/design_helpers.dart';

class MainView extends StatelessWidget {
  final MainModel model;

  MainView({this.model});

  

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double _targetWidth =
        deviceWidth > 550.0 ? 100.0 : deviceWidth * 0.45;
    return Scaffold(
      body: Container(
        width: deviceWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Color.fromRGBO(0, 0, 0, 0.15), BlendMode.dstATop),
            image: AssetImage('assets/logo.png'),
          ),
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 0),
          children: <Widget>[
            MainBanner(title: 'JARS APP'),
            SizedBox(height: 20),
            buildDivider(title: 'jars'),
            SizedBox(height: 20),
            AllJars(model: model),
          ],
        ),
      ),
    );
  }
}
