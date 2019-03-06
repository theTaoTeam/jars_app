import 'package:flutter/material.dart';

class BannerAction extends StatelessWidget {
  final String action;

  BannerAction({this.action});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print('$action pressed');
          },
        ),
        Text('add new $action'),
      ],
    );
  }
}
