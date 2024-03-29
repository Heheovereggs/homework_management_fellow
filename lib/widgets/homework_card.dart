import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeworkCard extends StatelessWidget {
  HomeworkCard(this.homework);
  final Homework homework;

  @override
  Widget build(BuildContext context) {
    bool? use24HFormat = Provider.of<DataService>(context, listen: false).student.use24HFormat;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Slidable(
        actionPane: SlidableBehindActionPane(),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: homework.dueDate.isAfter(DateTime.now()) ? Colors.lightBlueAccent : Colors.grey.shade400,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
            child: Stack(
              clipBehavior: Clip.antiAlias,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homework.name,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      use24HFormat
                          ? 'Due date: ${DateFormat.MMMMEEEEd().add_Hm().format(homework.dueDate)}'
                          : 'Due date: ${DateFormat.MMMMEEEEd().add_jm().format(homework.dueDate)}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      'Subject: ${homework.subjectName}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    if (homework.note != "")
                      Text(
                        'Note: ${homework.note}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(homework.platformName),
                      ],
                    ),
                  ],
                ),
                //TODO: add triangle
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconSlideAction(
            caption: 'Pin',
            foregroundColor: Colors.white,
            color: Colors.orange,
            icon: Icons.push_pin,
            onTap: () {
              print("pin pin pin");
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              FirebaseService firebaseService = FirebaseService();
              firebaseService.deleteHomework(homework, context);
            },
          ),
        ],
      ),
    );
  }
}
