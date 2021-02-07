import 'package:flutter/material.dart';
import 'package:homework_management_fellow/widgets/task_list.dart';

class PrivateTaskScreen extends StatefulWidget {
  @override
  _PrivateTaskScreenState createState() => _PrivateTaskScreenState();
}

class _PrivateTaskScreenState extends State<PrivateTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return TaskList();
  }
}
