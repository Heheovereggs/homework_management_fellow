import 'package:flutter/material.dart';

class SudoScreen extends StatelessWidget {
  static const String id = 'SudoScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("Super user setting"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.transfer_within_a_station_rounded),
              iconSize: 29,
              onPressed: () {},
            )
          ]),
      body: Container(),
    );
  }
}
