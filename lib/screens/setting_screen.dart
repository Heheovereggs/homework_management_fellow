import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/useless_calculator.dart';

class SettingScreen extends StatelessWidget {
  static const String id = 'SettingScreen';

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
              icon: Icon(Icons.height_rounded),
              iconSize: 29,
              onPressed: () {
                Navigator.pushNamed(context, UselessCalculator.id);
              },
            )
          ]),
    );
  }
}
