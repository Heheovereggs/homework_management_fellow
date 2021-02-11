import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Icon(Icons.arrow_back_ios_rounded),
        middle: Text("Setting"),
        trailing: Icon(Icons.info_outline_rounded),
      ),
      child: Text("Setting"),
    );
  }
}
