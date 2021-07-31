import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:homework_management_fellow/model/theme.dart';
import 'package:homework_management_fellow/screens/task_screen_master.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivationPendingScreen extends StatelessWidget {
  static const String id = 'ActivationPendingScreen';

  @override
  Widget build(BuildContext context) {
    bool isActivate = false;
    Size size = MediaQuery.of(context).size;
    Gradient gradient1 = LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Gradient gradient2 = LinearGradient(colors: [Colors.orangeAccent, Colors.pinkAccent]);
    Shader shader1 = gradient1.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Shader shader2 = gradient2.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Future<bool> checkStudentStatus() async {
      final prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      print(email);
      String? uid = prefs.getString('uid');
      print(uid);
      FirebaseService firebaseService = FirebaseService();
      return await firebaseService.checkStudent(email: email, uid: uid);
    }

    return Scaffold(
      body: ProgressHUD(
        indicatorWidget: CupertinoActivityIndicator(radius: 30),
        barrierEnabled: false,
        child: Builder(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Activation pending",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = shader2,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Please check later or press the button to refresh status",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()..shader = shader1,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.all(19),
                child: SizedBox(
                  width: 190,
                  height: 58,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: kBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                      child: Text(
                        'Refresh',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () async {
                        final progress = ProgressHUD.of(context);
                        progress?.show();
                        isActivate = await checkStudentStatus();
                        progress?.dismiss();
                        if (isActivate == false) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Hasn't activated yet...")));
                        } else {
                          Provider.of<DataService>(context, listen: false).student.activate = true;
                          Navigator.pushReplacementNamed(context, TaskScreenMaster.id);
                        }
                      }),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
