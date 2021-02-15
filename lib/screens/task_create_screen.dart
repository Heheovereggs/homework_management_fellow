import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TaskCreatePage extends StatefulWidget {
  @override
  _TaskCreatePageState createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _whereController = TextEditingController();
  final _noteController = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  DateTime _chosenDateTime;
  String dateTimeShown;

  bool isAdmin = false;
  String taskType;

  @override
  void initState() {
    taskType = (isAdmin == true) ? 'public' : 'private';
    dateTimeShown = dateFormat.format(DateTime.now());
    super.initState();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 400,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 300,
              child: CupertinoDatePicker(
                  minimumDate: DateTime.now(),
                  initialDateTime: DateTime.now(),
                  onDateTimeChanged: (val) {
                    setState(() {
                      _chosenDateTime = val;
                      print("back $_chosenDateTime");
                      dateTimeShown = dateFormat.format(_chosenDateTime);
                      print("dateTimeShown: $dateTimeShown");
                    });
                  }),
            ),

            // Close the modal
            Container(
              width: 300,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xFF2196f3),
                child: Text(
                  'OK',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Color(0xFF2196f3),
        leading: Icon(
          Icons.help_outline_rounded,
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
      child: CupertinoScrollbar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Add homework",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(9),
                child: Text(
                  "Choose the way you want to add:",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 335,
                  child: CupertinoSlidingSegmentedControl(
                    thumbColor: Color(0xFF2196f3),
                    groupValue: taskType,
                    onValueChanged: (value) {
                      setState(() {
                        taskType = value;
                      });
                    },
                    children: <String, Widget>{
                      "public": Text(
                        "Public",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      "private": Text(
                        "Private",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    },
                  ),
                ),
              ),
              taskTextFormField(hintText: "Title", textController: _titleController),
              taskTextFormField(hintText: "Subject", textController: _subjectController),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Due date: $dateTimeShown",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
                    child: Text(
                      "Pick",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Color(0xFF2196f3)),
                    ),
                    onPressed: () {
                      _showDatePicker();
                    },
                  ),
                ],
              ),
              taskTextFormField(
                  hintText: "Where to submit (Léa/Mio/Teams, etc.)", textController: _whereController),
              taskTextFormField(
                  isLast: true,
                  boxHeight: 90,
                  hintText: "Note (optional)",
                  textController: _noteController,
                  maxLine: 3),
              if (taskType == "public" && isAdmin == false)
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Text(
                      "Your public homework post will temporarily save as Private until admin approval",
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2196f3),
                    child: Text(
                      (taskType == "public") ? "Post" : "Add",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      if (taskType == "private") {
                        //TODO: call provider to sync private task
                      } else if (taskType == "public") {
                        if (isAdmin) {
                          //TODO: call provider to cast task
                        } else {
                          //TODO: call provider to sync private task, and set isWaiting==true
                        }
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Container(
                  width: 300,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.red,
                    child: Text(
                      'Clean all inputs',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        print(dateTimeShown);
                        _titleController.clear();
                        _noteController.clear();
                        _whereController.clear();
                        _subjectController.clear();
                        dateTimeShown = dateFormat.format(DateTime.now());
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox taskTextFormField(
      {double boxHeight = 60,
      String hintText,
      TextEditingController textController,
      int maxLine = 1,
      bool isLast = false}) {
    return SizedBox(
      height: boxHeight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CupertinoTextField(
          maxLines: maxLine,
          placeholder: hintText,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(),
          ),
          autocorrect: true,
          autofocus: true,
          controller: textController,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        ),
      ),
    );
  }
}
