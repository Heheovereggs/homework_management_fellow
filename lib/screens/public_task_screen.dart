import 'package:flutter/material.dart';
import 'package:homework_management_fellow/widgets/task_list.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'TaskScreen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String uid;
  String email;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TaskList();
  }
}
