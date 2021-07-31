import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/useless_calculator.dart';
import 'package:homework_management_fellow/screens/section_select_screen.dart';
import 'package:homework_management_fellow/screens/sudo_screen.dart';
import 'screens/activation_pending_screen.dart';
import 'screens/banned_screen.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:provider/provider.dart';
import 'screens/setting_screen.dart';
import 'screens/task_screen_master.dart';
import 'screens/welcome_screen.dart';
import 'screens/registration_screen.dart';
import 'package:flutter/services.dart';
import 'package:homework_management_fellow/model/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    ChangeNotifierProvider(create: (_) => DataService(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().appTheme,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      initialRoute: WelcomeScreen.id,
      routes: {
        ActivationPendingScreen.id: (context) => ActivationPendingScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        TaskScreenMaster.id: (context) => TaskScreenMaster(),
        SettingScreen.id: (context) => SettingScreen(),
        BannedScreen.id: (context) => BannedScreen(),
        SectionSelectScreen.id: (context) => SectionSelectScreen(),
        SudoScreen.id: (context) => SudoScreen(),
        UselessCalculator.id: (context) => UselessCalculator(),
      },
    );
  }
}
