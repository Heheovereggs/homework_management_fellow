import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/screens/activation_pending_screen.dart';
import 'package:homework_management_fellow/screens/banned_screen.dart';
import 'package:homework_management_fellow/screens/registration_screen.dart';
import 'package:homework_management_fellow/screens/section_select_screen.dart';
import 'package:homework_management_fellow/screens/task_screen_master.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/google_sign_in.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  static const String id = 'WelcomeScreen';

  late final Student? student;

  void _loadStudent(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? uid = prefs.getString('uid');
    print("read $email from SharedPreferences");
    print("read $uid from SharedPreferences");
    if (email != null && uid != null) {
      FirebaseService firebaseService = FirebaseService();
      await firebaseService.checkStudent(email: email, uid: uid);
      Student? _student = firebaseService.getStudent();
      if (_student != null) {
        Provider.of<DataService>(context, listen: false).setStudent(_student);
        if (_student.ban) {
          Navigator.pushReplacementNamed(context, BannedScreen.id);
        } else if (_student.sectionIds == null || _student.sectionIds!.isEmpty) {
          Navigator.pushReplacementNamed(context, SectionSelectScreen.id,
              arguments: {'email': email, 'uid': uid});
        } else if (!_student.activate) {
          Navigator.pushReplacementNamed(context, ActivationPendingScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, TaskScreenMaster.id);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadStudent(context);
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    return Scaffold(
      body: ProgressHUD(
        indicatorWidget: CupertinoActivityIndicator(radius: 50),
        barrierEnabled: false,
        child: Builder(builder: (context) {
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Homework management fellow", style: TextStyle(fontSize: 25)),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "No icon was designed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = shader,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  OutlineButton(
                    splashColor: Colors.grey,
                    onPressed: () => buttonOnPressed(context),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(image: AssetImage("images/google_logo.png"), height: 35.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign/Log in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<void> buttonOnPressed(BuildContext context) async {
    String? email;
    String? uid;
    final progress = ProgressHUD.of(context);
    progress?.show();
    signInWithGoogle().then(
      (result) async {
        email = result![0];
        uid = result[1];
        FirebaseService firebaseService = FirebaseService();
        await firebaseService.checkStudent(email: email, uid: uid);
        Student? student = firebaseService.getStudent();
        progress?.dismiss();
        if (email != null) {
          if (student == null) {
            Navigator.pushReplacementNamed(context, RegistrationScreen.id,
                arguments: {'email': email, 'uid': uid});
          } else if (student.ban) {
            Navigator.pushReplacementNamed(context, BannedScreen.id);
          } else if (student.sectionIds == null || student.sectionIds!.isEmpty) {
            Navigator.pushReplacementNamed(context, SectionSelectScreen.id,
                arguments: {'email': email, 'uid': uid});
          } else if (!student.activate) {
            Navigator.pushReplacementNamed(context, ActivationPendingScreen.id);
          } else {
            Navigator.pushReplacementNamed(context, TaskScreenMaster.id);
          }
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
              title: Text("Login failed"),
              content: Text("Please try again"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Dismiss"))
              ],
            ),
          );
        }
      },
    );
  }
}
