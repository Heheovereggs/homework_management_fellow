import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/task_screen.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
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
      print("oooooooooooooooooooooooooooooo");
      Student student =
          await Provider.of<FirebaseService>(context, listen: false).checkStudent(email: email, uid: uid);
      print("wwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
      return student.activate;
    }

    return Scaffold(
      body: ModalProgressHUD(
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
                  "PLease check later or press the button to refresh status",
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
                    width: 180,
                    child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Color(0xFF2196f3),
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Refresh',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _showSpinner = true;
                          });
                          isActivate = await checkStudentStatus();
                          print("setsetsetsetsetset");
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
                            Navigator.pushNamed(context, TaskScreen.id);
                          }
                        }),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                  child: Container(
                    width: 175,
                    height: 45,
                    decoration:
                        BoxDecoration(color: Color(0xCC000000), borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "Hasn't activated yet...",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
