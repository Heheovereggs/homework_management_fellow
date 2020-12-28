import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/setting_screen.dart';
import 'screens/task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: TaskScreen.id,
      routes: {
        TaskScreen.id: (context) => TaskScreen(),
        SettingScreen.id: (context) => SettingScreen(),
      },
    );
  }
}
