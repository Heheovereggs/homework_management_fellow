import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/widgets/task_create_page.dart';
import 'screens/activation_pending_screen.dart';
import 'screens/banned_screen.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/stateService.dart';
import 'package:provider/provider.dart';
import 'screens/setting_screen.dart';
import 'screens/public_task_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StateService()),
        Provider(create: (_) => FirebaseService())
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
      initialRoute: TaskScreen.id,
      routes: {
        ActivationPendingScreen.id: (context) => ActivationPendingScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        TaskScreen.id: (context) => TaskScreen(),
        SettingScreen.id: (context) => SettingScreen(),
        BannedScreen.id: (context) => BannedScreen(),
        TaskCreatePage.id: (context) => TaskCreatePage(),
      },
    );
  }
}
