import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/sign_in.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _showSpinner = false;
  Student student;

  @override
  void initState() {
    super.initState();
    loadStudent();
  }

  void loadStudent() async {
    final prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String uid = prefs.getString('uid');
    print("read $email from local SSD");
    print("read $uid from local SSD");
    if (email != null && uid != null) {
      Student _student =
          await Provider.of<FirebaseService>(context, listen: false).checkStudent(email: email, uid: uid);
      Provider.of<DataService>(context, listen: false).setStudent(_student);
      if (_student != null) {
        if (_student.ban) {
          Navigator.pushNamed(context, '/BannedScreen');
        } else if (!_student.activate) {
          Navigator.pushNamed(context, '/ActivationPendingScreen');
        } else {
          Navigator.pushNamed(context, '/TaskScreen');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     registeredCheck("xxx@xx.com");
      //   },
      //   child: Icon(Icons.download_rounded),
      // ),
      body: ModalProgressHUD(
        progressIndicator: CupertinoActivityIndicator(
          radius: 50,
        ),
        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Homework management fellow", style: TextStyle(fontSize: 25)),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "No icon was designed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = shader,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: buttonOnPressed,
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
        ),
      ),
    );
  }

  Future<void> buttonOnPressed() async {
    String email;
    String uid;
    Student student;
    setState(() {
      _showSpinner = true;
    });
    signInWithGoogle().then(
      (result) async {
        email = result[0];
        uid = result[1];
        student =
            await Provider.of<FirebaseService>(context, listen: false).checkStudent(email: email, uid: uid);
        Provider.of<DataService>(context, listen: false).setStudent(student);
        setState(() {
          _showSpinner = false;
        });
        if (email != null) {
          if (student == null) {
            Navigator.pushNamed(context, '/RegistrationScreen', arguments: {'email': email, 'uid': uid});
          } else if (student.ban) {
            Navigator.pushNamed(context, '/BannedScreen');
          } else if (!student.activate) {
            Navigator.pushNamed(context, '/ActivationPendingScreen');
          } else {
            Navigator.pushNamed(context, '/TaskScreen');
          }
        } else {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
              title: Text("Login failed"),
              content: Text("Please try again"),
              actions: [
                FlatButton(
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
