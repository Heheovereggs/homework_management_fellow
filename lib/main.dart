import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/task_create_screen.dart';
import 'screens/activation_pending_screen.dart';
import 'screens/banned_screen.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/stateService.dart';
import 'package:provider/provider.dart';
import 'screens/setting_screen.dart';
import 'screens/main_task_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/registration_screen.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateService()),
        Provider(create: (_) => FirebaseService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
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
      )),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      initialRoute: '/WelcomeScreen',
      routes: {
        '/ActivationPendingScreen': (context) => ActivationPendingScreen(),
        '/RegistrationScreen': (context) => RegistrationScreen(),
        '/WelcomeScreen': (context) => WelcomeScreen(),
        '/TaskScreen': (context) => TaskScreen(),
        '/SettingScreen': (context) => SettingScreen(),
        '/BannedScreen': (context) => BannedScreen(),
        '/TaskCreatePage': (context) => TaskCreatePage(),
      },
    );
  }
}
