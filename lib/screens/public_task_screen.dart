import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/stateService.dart';
import 'package:homework_management_fellow/widgets/task_list.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'TaskScreen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  void initState() {
    super.initState();
    loadHomeworkList();
  }

  void loadHomeworkList() async {
    String uid = Provider.of<StateService>(context, listen: false).student.uid;
    List<Homework> homeworkList =
        await Provider.of<FirebaseService>(context, listen: false).getHomeWorkList(uid);
    Provider.of<StateService>(context, listen: false).setPublicHomeworkList(homeworkList);
  }

  @override
  Widget build(BuildContext context) {
    return TaskList();
  }
}
