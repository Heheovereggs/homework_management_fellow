import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Setting"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline_rounded),
              iconSize: 29,
              onPressed: () {},
            )
          ]),
    );
  }
}
