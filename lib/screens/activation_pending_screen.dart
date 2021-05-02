import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/task_screen_master.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/widgets/boxed_text_note.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homework_management_fellow/model/student.dart';

class ActivationPendingScreen extends StatefulWidget {
  static const String id = 'ActivationPendingScreen';

  @override
  _ActivationPendingScreenState createState() => _ActivationPendingScreenState();
}

class _ActivationPendingScreenState extends State<ActivationPendingScreen> {
  bool _showSpinner = false;
  bool isActivate = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Gradient gradient1 = LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Gradient gradient2 = LinearGradient(colors: [Colors.orangeAccent, Colors.pinkAccent]);
    Shader shader1 = gradient1.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    Shader shader2 = gradient2.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Future<bool> checkStudentStatus() async {
      final prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email');
      print(email);
      String uid = prefs.getString('uid');
      print(uid);
      Student student =
          await Provider.of<FirebaseService>(context, listen: false).checkStudent(email: email, uid: uid);
      return student.activate;
    }

    return Scaffold(
      body: ModalProgressHUD(
        progressIndicator: CupertinoActivityIndicator(
          radius: 30,
        ),
        inAsyncCall: _showSpinner,
        child: Stack(
          children: [
            Column(
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
                            backgroundColor: Color(0xFF2196f3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                        child: Text(
                          'Refresh',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _showSpinner = true;
                          });
                          isActivate = await checkStudentStatus();
                          setState(() {
                            _showSpinner = false;
                          });
                          if (isActivate == false) {
                            setState(() {
                              _visible = true;
                            });
                            Future.delayed(Duration(milliseconds: 1500), () {
                              setState(() {
                                _visible = false;
                              });
                            });
                          } else {
                            Provider.of<DataService>(context, listen: false).student.activate = true;
                            Navigator.pushNamed(context, '/TaskScreenMaster');
                          }
                        }),
                  ),
                ),
              ],
            ),
            UserSeeOnlyNotification(visible: _visible, text: "Hasn't activated yet...")
          ],
        ),
      ),
    );
  }
}
