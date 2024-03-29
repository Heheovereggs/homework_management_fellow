import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    String? uid = prefs.getString('uid');
    if (!Provider.of<DataService>(context, listen: false).isPrivateHomeworkLoaded) {
      FirebaseService firebaseService = FirebaseService();
      await firebaseService.loadPrivateHomeWorkList(uid);
      Provider.of<DataService>(context, listen: false)
          .initializePrivateHomeworkList(firebaseService.getHomeworkList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataService>(
      builder: (_, stateService, child) {
        if (stateService.isPrivateHomeworkLoaded == false) {
          return Container();
        }
        if (stateService.privateHomeworkList.length == 0) {
          return Center(
              child: Text(
                  "No task has been added at the moment.\nClick the ➕ button below to add Private task",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1));
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
