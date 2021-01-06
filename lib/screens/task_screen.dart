import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:flutter/material.dart';

import '../widgets/homework_card.dart';

class TaskScreen extends StatefulWidget {
  static const String id = 'TaskScreen';

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool isActivated = false; //TODO: create a function below to check if account activated yet

  @override
  void initState() {
    if (isActivated == false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Registration pending"),
          content: Text("Your account need admin approve"),
          actions: [
            FlatButton(
              child: Text("Refresh"),
              onPressed: () {
                // TODO: get new account stat from server and rebuild page
              },
            ),
          ],
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            // TODO: pop up card
          },
          child: Icon(Icons.settings),
        ),
        title: Text("HMF"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              // TODO: pop up card
            },
          ),
          SizedBox(width: 8)
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: stackGenerator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          // TODO: add pop up panel
        },
      ),
    );
  }
}

List<HomeworkCard> stackGenerator() {
  return [
    HomeworkCard(name: "101", dueDate: "1212", subject: "123"),
    HomeworkCard(name: "102", dueDate: "1212", subject: "123"),
    HomeworkCard(name: "247", dueDate: "1212", subject: "123"),
    HomeworkCard(name: "206", dueDate: "1212", subject: "123"),
    HomeworkCard(name: "207", dueDate: "1212", subject: "123"),
  ];
}
