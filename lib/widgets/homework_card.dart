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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(),
        ],
      ),
    );
  }
}
