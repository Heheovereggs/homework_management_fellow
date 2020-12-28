import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatelessWidget {
  static const String id = 'TaskScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HMF"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: add list
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [HomeworkCard(name: "123", dueDate: "1212", subject: "123")],
          ),
        ),
      ),
    );
  }
}
