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
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Due date ${homework.dueDate}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Subject: ${homework.subjectName}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  'Where: ${homework.where}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                if (homework.note != "")
                  Text(
                    'Note: ${homework.note}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
