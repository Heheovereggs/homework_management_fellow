import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/stateService.dart';
import 'package:homework_management_fellow/widgets/task_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'TaskScreen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Homework> homeworkList = [];
  void initState() {
    super.initState();
    loadHomeworkList();
  }

  void loadHomeworkList() async {
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    List<Homework> _homeworkList =
        await Provider.of<FirebaseService>(context, listen: false).getPublicHomeWorkList(uid);
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
