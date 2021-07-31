import 'package:flutter/material.dart';

class AppTheme {
  ThemeData appTheme = ThemeData(
    buttonTheme: ButtonThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
    colorScheme: ColorScheme.light(
      primary: kBlue,
      onSecondary: Colors.white,
    ),
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

// Color kBlue = const Color(0xFF2196f3);
Color kBlue = Colors.lightBlue;
