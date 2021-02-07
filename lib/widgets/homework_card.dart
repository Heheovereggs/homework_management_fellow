import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';

class HomeworkCard extends StatelessWidget {
  HomeworkCard(this.homework);
  final Homework homework;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(9, 10, 9, 0),
      child: Container(
        height: 150,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Colors.lightBlueAccent,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Name: ${homework.name}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Due date ${homework.dueDate}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Subject: ${homework.subject}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Where: ${homework.where}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Note: ${homework.note}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
