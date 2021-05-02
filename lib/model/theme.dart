import 'package:flutter/material.dart';

class AppTheme {
  ThemeData appTheme = ThemeData(
    textTheme: TextTheme(
      bodyText1: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          fontFamily: 'SF Pro'),
      bodyText2: TextStyle(
          fontSize: 19,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          fontFamily: 'SF Pro'),
      caption: TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          decoration: TextDecoration.none,
          fontFamily: 'SF Pro'),
    ),
  );
}
