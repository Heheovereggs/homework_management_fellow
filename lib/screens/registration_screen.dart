import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_screen.dart';
import 'welcome_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _firestore = FirebaseFirestore.instance;
  String firstName;
  String lastName;
  bool isDiscord = false;
  String uid;
  String email;

  @override
  void initState() {
    getLoginInfo();
    super.initState();
  }

  void getLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? '';
      uid = prefs.getString('uid') ?? '';
    });
  }

  void saveLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('uid', uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  "Your email: $email",
                  style: TextStyle(fontSize: 24, height: 1.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: registrationTextField(firstName, "First name"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: registrationTextField(lastName, "Last name"),
              ),
              Padding(
                padding: const EdgeInsets.all(9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Are you in CET Discord server?",
                      style: TextStyle(fontSize: 19),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              value: isDiscord,
                              items: [
                                DropdownMenuItem(child: Text("Yes"), value: true),
                                DropdownMenuItem(child: Text("No"), value: false),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  isDiscord = value;
                                  print(isDiscord);
                                });
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9),
                child: Container(
                  height: 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: Text(
                    "No password required since Gooooooooooooooogle will do the verification",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(19),
                child: SizedBox(
                  width: 350,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2196f3),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      saveLoginInfo();
                      _firestore.collection('user').doc('$uid').set({
                        'uid': uid,
                        'email': email,
                        'FirstName': firstName,
                        'LastName': lastName,
                        'activate': false,
                        'admin': false,
                        'ban': false,
                        'theme': null,
                      });
                      //To be move to admin screen:
                      // _firestore.collection('user').doc('$uid').set({
                      //   'dateofJoin': Timestamp.now(),
                      //   'activate': true,
                      // });
                      Navigator.pushNamed(context, TaskScreen.id);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField registrationTextField(String value, final String hint) {
    return TextField(
      autocorrect: false,
      autofocus: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
      ),
      onChanged: (text) {
        value = text;
        print(value);
      },
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
    );
  }
}
