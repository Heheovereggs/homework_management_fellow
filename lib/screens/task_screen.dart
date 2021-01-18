import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/task_layout.dart';
import 'welcome_screen.dart';

class TaskScreen extends StatelessWidget {
  static const String id = 'TaskScreen';

  final _firestore = FirebaseFirestore.instance;
  final String uid;
  final String email;
  final bool isActivated = false;

  TaskScreen({Key key, this.uid, this.email}) : super(key: key);

  void initState(BuildContext context) {
    Future.delayed(Duration(milliseconds: 200), () {
      LocalStorage(name: uid, value: "uid").getLoginInfo();
      LocalStorage(name: email, value: "email").getLoginInfo();
      // activateCheck(uid);
      if (isActivated == false) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  return isActivated;
                },
                child: AlertDialog(
                  title: Text("Activation pending"),
                  content: Text("Your account is waiting to be activate by admin, please check later"),
                  actions: [
                    FlatButton(
                      child: Text("Refresh"),
                      onPressed: () {
                        activateCheck(uid);
                      },
                    ),
                  ],
                ),
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TaskScreenLayout(context: context, email: email).taskLayoutGenerator();
  }

  Future<bool> activateCheck(String uid) async {
    var userInfo = await _firestore.collection("user/$uid/activate").get();
    for (var userInf in userInfo.docs) {
      print(userInf);
      // if (userInf == true) {
      //   return true;
      // } else {
      //   return false;
      // }
    }
  }
}
