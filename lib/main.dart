import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/services/stateService.dart';
import 'package:provider/provider.dart';
import 'screens/setting_screen.dart';
import 'screens/task_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        TaskScreen.id: (context) => TaskScreen(),
        SettingScreen.id: (context) => SettingScreen(),
      },
    );
  }
}
