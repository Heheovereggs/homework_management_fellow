import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateTaskScreen extends StatefulWidget {
  @override
  _PrivateTaskScreenState createState() => _PrivateTaskScreenState();
}

class _PrivateTaskScreenState extends State<PrivateTaskScreen> {
  List<Homework> homeworkList = [];
  @override
  void initState() {
    loadHomeworkList();
    super.initState();
  }

  void loadHomeworkList() async {
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    List<Homework> _homeworkList = await Provider.of<FirebaseService>(context, listen: false).getPrivateHomeWorkList(uid);
    // Provider.of<StateService>(context, listen: false).setPublicHomeworkList(homeworkList);
    setState(() {
      homeworkList = _homeworkList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF2196f3),
        leading: Icon(
          Icons.filter_alt,
          color: Colors.white,
        ),
        middle: Text(
          "HMF",
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ),
      child: homeworkList != null
          ? taskListBuilder()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("No task been added atm"),
            ),
    );
  }

  CupertinoScrollbar taskListBuilder() {
    return CupertinoScrollbar(
      child: ListView.builder(
        itemCount: homeworkList.length,
        itemBuilder: (BuildContext context, int index) {
          return HomeworkCard(homeworkList[index]);
        },
      ),
    );
  }
}
