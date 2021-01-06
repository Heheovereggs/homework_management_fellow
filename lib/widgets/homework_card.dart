import 'package:flutter/material.dart';

class HomeworkCard extends StatelessWidget {
  HomeworkCard({@required this.name, @required this.dueDate, @required this.subject, this.note});
  final String name;
  final String dueDate;
  final String subject;
  final String note;

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
            child: Text(
              '$name',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
