import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/stateService.dart';
import 'package:provider/provider.dart';
import 'task_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String firstName;
  String lastName;
  bool isDiscord = false;
  String uid;
  String email;
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    email = arguments['email'];
    uid = arguments['uid'];
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
                child: Consumer<StateService>(builder: (context, stateService, child) {
                  return Text(
                    "Your email: $email",
                    style: TextStyle(fontSize: 24, height: 1.3),
                  );
                }),
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
                      firebaseService.saveLoginInfo(
                          uid: uid,
                          email: email,
                          firstName: firstName,
                          lastName: lastName,
                          isDiscord: isDiscord);
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
