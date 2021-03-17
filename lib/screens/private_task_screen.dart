import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateTaskScreen extends StatefulWidget {
  @override
  _PrivateTaskScreenState createState() => _PrivateTaskScreenState();
}

class _PrivateTaskScreenState extends State<PrivateTaskScreen> {
  @override
  void initState() {
    loadPrivateHomeworkList();
    super.initState();
  }

  void loadPrivateHomeworkList() async {
    final prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    if (!Provider.of<DataService>(context, listen: false).isHomeworkListLoaded) {
      List<Homework> _homeworkList =
          await Provider.of<FirebaseService>(context, listen: false).getPrivateHomeWorkList(uid);
      Provider.of<DataService>(context, listen: false).setPrivateHomeworkList(_homeworkList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (_, stateService, child) {
        if (stateService.isHomeworkListLoaded == false) {
          return Container();
        }
        if (stateService.privateHomeworkList.length == 0) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("No task has been added at the moment."),
          );
        }
        return CupertinoScrollbar(
          child: ListView.builder(
            itemCount: stateService.privateHomeworkList.length,
            itemBuilder: (BuildContext context, int index) {
              return HomeworkCard(stateService.privateHomeworkList[index]);
            },
          ),
        );
      },
    );
  }
}
