import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/task_layout.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'TaskScreen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _firestore = FirebaseFirestore.instance;
  String uid;
  String email;
  bool isActivated = false;

  void initState() {
    Future.delayed(Duration.zero, () {
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
    super.initState();
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
