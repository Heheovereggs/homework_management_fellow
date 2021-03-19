import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:homework_management_fellow/model/subject.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/widgets/boxed_text_note.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:homework_management_fellow/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskCreatePage extends StatefulWidget {
  @override
  _TaskCreatePageState createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _whereController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  DateTime _chosenDateTime;
  String dateTimeShown;
  bool isAdmin = false;
  String taskType;
  List<Subject> subjects;
  Map submitPlatforms;
  bool showSubjectPopup = false;
  bool showWherePopup = false;
  String uid;
  List<String> subjectNameList = [];
  String sectionId = "";
  String sectionNumber;

  @override
  void initState() {
    taskType = (isAdmin == true) ? 'sectionOnly' : 'singleStudentOnly';
    dateTimeShown = dateFormat.format(DateTime.now());
    getDataFromDatabase();
    super.initState();
  }

  Future getDataFromDatabase() async {
    subjects = await Provider.of<FirebaseService>(context, listen: false).getSubjectList();
    submitPlatforms = await Provider.of<FirebaseService>(context, listen: false).getSubmitPlatform();
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
    setState(() {});
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
                      dateTimeShown = dateFormat.format(_chosenDateTime);
                    });
                  }),
            ),

            // Close the modal
            ConfirmButton(
              context: context,
              onPress: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _generateSubjectPicker() {
    List<Widget> subjectWidgets = [];
    int count = 0;
    for (Subject i in subjects) {
      subjectWidgets.add(Center(child: Text(i.name)));
      subjectNameList.add(i.name);
      count++;
    }
    showCupertinoPicker(
      itemList: subjectWidgets,
      itemCount: count,
      additionalTextField: showSubjectPopup,
      additionalPrompt: "Enter your subject",
      textController: _subjectController,
      visualNameList: subjectNameList,
      isInputSubject: true,
    );
  }

  Future _getSectionIdsForChosenSubject() async {
    List sectionIdsForOneSubject;
    List studentSectionIdList;
    String subjectId;
    if (subjectNameList.contains(_subjectController.text)) {
      studentSectionIdList = Provider.of<DataService>(context, listen: false).student.sectionIds;
      for (var subject in subjects) {
        if (subject.name == _subjectController.text) {
          subjectId = subject.id;
          break;
        }
      }
      sectionIdsForOneSubject =
          await Provider.of<FirebaseService>(context, listen: false).getSections(subjectId: subjectId);
      for (SubjectSection subjectSection in sectionIdsForOneSubject) {
        if (studentSectionIdList.contains(subjectSection.id)) {
          sectionId = subjectSection.id;
          sectionNumber = subjectSection.section;
          break;
        }
      }
    }
  }

  void _generateWherePicker() {
    List<Widget> platformWidgets = [];
    List<String> platformNameList = [];
    int count = 0;
    for (String key in submitPlatforms.keys) {
      String name = submitPlatforms[key];
      platformWidgets.add(Center(child: Text(name)));
      platformNameList.add(name);
      count++;
    }
    showCupertinoPicker(
      itemList: platformWidgets,
      itemCount: count,
      additionalTextField: showWherePopup,
      additionalPrompt: "Enter other platform",
      textController: _whereController,
      visualNameList: platformNameList,
    );
  }

  Future showCupertinoPicker({
    @required List<Widget> itemList,
    @required bool additionalTextField,
    @required String additionalPrompt,
    @required int itemCount,
    @required textController,
    @required List visualNameList,
    bool isInputSubject = false,
  }) {
    itemList.add(Center(child: Text("Other")));
    return showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 400,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 300,
              child: CupertinoPicker(
                onSelectedItemChanged: (int value) {
                  if (value == itemCount) {
                    additionalTextField = true;
                    if (isInputSubject) {
                      sectionId = "";
                    }
                  } else {
                    textController.text = visualNameList[value];
                    additionalTextField = false;
                    if (isInputSubject) {
                      _getSectionIdsForChosenSubject();
                    }
                  }
                },
                itemExtent: 32,
                children: itemList,
              ),
            ),
            // Close the modal
            ConfirmButton(
              context: context,
              onPress: () {
                if (additionalTextField) {
                  textController.clear();
                  _showAdditionalTextField(hintText: additionalPrompt, textController: textController);
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future _showAdditionalTextField({@required String hintText, @required textController}) {
    return showCupertinoModalPopup(
        barrierDismissible: false,
        context: context,
        builder: (_) => Container(
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: taskTextFormField(hintText: hintText, textController: textController)),
                  SizedBox(height: 20),
                  ConfirmButton(
                    context: context,
                    onPress: () {
                      Navigator.popUntil(context, ModalRoute.withName('/TaskScreenMaster'));
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Form(
          key: _formKey,
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
                      "sectionOnly": Text(
                        "Public",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      "singleStudentOnly": Text(
                        "Private",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      "fullyPublic": Text(
                        "All ⚠️",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    },
                  ),
                ),
              ),
              taskTextFormField(hintText: "Title", textController: _titleController),
              SizedBox(
                height: 35,
                child: IOSStyleButton(
                    paddingValue: EdgeInsets.all(0),
                    buttonOnPress: _generateSubjectPicker,
                    primaryText: (sectionId == "")
                        ? ("Subject: ${_subjectController.text}")
                        : ("Subject: ${_subjectController.text} sect.000$sectionNumber"),
                    secondaryText: _subjectController.text == "" ? "\tPress to choose" : null,
                    buttonColor: null,
                    primaryTextColor: Colors.black,
                    secondaryTextColor: Colors.black45),
              ),
              SizedBox(
                height: 35,
                child: IOSStyleButton(
                    paddingValue: EdgeInsets.all(0),
                    buttonOnPress: _generateWherePicker,
                    primaryText: "Submit platform: ${_whereController.text}",
                    secondaryText: _whereController.text == "" ? "\tPress to choose" : null,
                    buttonColor: null,
                    primaryTextColor: Colors.black,
                    secondaryTextColor: Colors.black45),
              ),
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
                  isLast: true,
                  boxHeight: 90,
                  hintText: "Note (optional)",
                  textController: _noteController,
                  maxLine: 3),
              if (taskType == "sectionOnly" && isAdmin == false)
                ExplanationText(
                    "Your Public (students in same section can see) homework post will temporarily save as Private until admin approval"),
              if (taskType == "fullyPublic")
                ExplanationText(
                    "⚠️Warning⚠️\nThis homework will be seen by ALL student in CET program, if you only wish to let student in the same section see with you please choose \"Public\" to add homework"),
              if (taskType == "fullyPublic" && isAdmin == false)
                ExplanationText(
                    "And this homework post will temporarily save as Private until admin approval"),
              IOSStyleButton(
                  buttonOnPress: _addHomework,
                  primaryText: taskType == "singleStudentOnly" ? "Add" : "Post",
                  primaryTextColor: Colors.white),
              IOSStyleButton(
                  buttonOnPress: _cleanAllInputs,
                  primaryText: 'Clean all inputs',
                  buttonColor: Colors.red,
                  primaryTextColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Future _addHomework() async {
    Homework homework = Homework(
      studentId: uid,
      category: isAdmin ? taskType : "singleStudentOnly",
      isWaiting:
          ((taskType == "sectionOnly" || taskType == "fullyPublic") && isAdmin == false) ? true : false,
      name: _titleController.text.trim(),
      subjectName: _subjectController.text.trim(),
      where: _whereController.text.trim(),
      note: _noteController.text.trim(),
      dueDate: _chosenDateTime,
      sectionId: sectionId,
    );

    if (homework.category == "singleStudentOnly") {
      Provider.of<DataService>(context, listen: false).privateHomeworkList.add(homework);
    }
    Provider.of<FirebaseService>(context, listen: false).uploadHomework(homework);
    _showCupertinoDialog();
    _cleanAllInputs();
  }

  void _showCupertinoDialog() {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => Container(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              width: 300,
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("This homework has been added",
                      style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold)),
                  Text("Current status: $taskType", style: Theme.of(context).textTheme.bodyText1),
                  Text("I am working on a stamp animation to replace this",
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1),
                  IOSStyleButton(
                    primaryText: 'OK',
                    primaryTextColor: Color(0xFF2196f3),
                    buttonColor: null,
                    buttonOnPress: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            )));
  }

  void _cleanAllInputs() {
    setState(() {
      _titleController.clear();
      _noteController.clear();
      _whereController.clear();
      _subjectController.clear();
      dateTimeShown = dateFormat.format(DateTime.now());
    });
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
