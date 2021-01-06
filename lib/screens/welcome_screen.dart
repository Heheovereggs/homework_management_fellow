import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/registration_screen.dart';
import 'package:homework_management_fellow/screens/task_screen.dart';
import 'package:homework_management_fellow/widgets/sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          registeredCheck("xxx@xx.com");
        },
        child: Icon(Icons.download_rounded),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
                  onPressed: () => authentication(showSpinner),
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

  Future<void> authentication(bool showSpinner) async {
    String email;
    bool isRegistered;
    setState(() {
      showSpinner = true;
    });
    signInWithGoogle().then(
      (result) async {
        email = result;
        isRegistered = await registeredCheck(email);
        setState(() {
          showSpinner = false;
        });
        if (email != null) {
          if (isRegistered == false) {
            Navigator.pushNamed(context, RegistrationScreen.id);
          } else {
            Navigator.pushNamed(context, TaskScreen.id);
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

  Future<bool> registeredCheck(String email) async {
    final userInfo = await _firestore.collection("user").get();
    for (var userInf in userInfo.docs) {
      print("info");
      print(userInf.data);
    }
    // TODO: check if email in data lists
    return false;
  }
}
