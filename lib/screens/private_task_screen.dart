import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/widgets/task_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateTaskScreen extends StatefulWidget {
  @override
  _PrivateTaskScreenState createState() => _PrivateTaskScreenState();
}

class _PrivateTaskScreenState extends State<PrivateTaskScreen> {
  List<Homework> homeworkList = [];

  void loadHomeworkList() async {
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    List<Homework> _homeworkList =
        await Provider.of<FirebaseService>(context, listen: false).getPrivateHomeWorkList(uid);
    // Provider.of<StateService>(context, listen: false).setPublicHomeworkList(homeworkList);
    setState(() {
      homeworkList = _homeworkList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TaskList(homeworkList);
  }
}
