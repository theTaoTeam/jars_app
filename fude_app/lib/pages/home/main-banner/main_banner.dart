import 'package:flutter/material.dart';

import 'package:fude/pages/home/main-banner/banner_action.dart';

class MainBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.width;
    return Container(
        height: deviceHeight * 0.6,
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              
              children: <Widget>[
                BannerAction(action: 'jar'),
                BannerAction(action: 'recipe'),
              ],
            ),
          ],
        ));
  }
}
