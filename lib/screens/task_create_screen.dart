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
import 'task_screen_master.dart';

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
  DateFormat dateFormat;
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
  String errorMessage;
  bool use24HFormat;
  int titleCharLimit = 20;
  int subjectCharLimit = 15;
  int platformCharLimit = 10;
  int noteCharLimit = 200;
  RegExp letter26 = RegExp(r'[a-z]+$', caseSensitive: false);

  @override
  void initState() {
    isAdmin = Provider.of<DataService>(context, listen: false).student.admin;
    use24HFormat = Provider.of<DataService>(context, listen: false).student.use24HFormat;
    dateFormat = use24HFormat ? DateFormat("yyyy-MM-dd HH:mm") : DateFormat("yyyy-MM-dd HH:mm a");
    taskType = (isAdmin == true) ? HomeworkType.sectionOnly : HomeworkType.singleStudentOnly;
    dateTimeShown = dateFormat.format(DateTime.now());
    _chosenDateTime = DateTime.now();
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
                  use24hFormat: use24HFormat,
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
      additionalPrompt: "Enter your subject (max $subjectCharLimit letters)",
      additionalCharLimit: subjectCharLimit,
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
          sectionNumber = (subjectSection.section.length == 1)
              ? "000${subjectSection.section}"
              : "00${subjectSection.section}";
          break;
        }
      }
    }
  }

  void _generatePlatformPicker() {
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
      additionalPrompt: "Enter platform name (max $platformCharLimit letters)",
      additionalCharLimit: platformCharLimit,
      textController: _whereController,
      visualNameList: platformNameList,
    );
  }

  Future showCupertinoPicker({
    @required List<Widget> itemList,
    @required bool additionalTextField,
    @required String additionalPrompt,
    @required int itemCount,
    @required TextEditingController textController,
    @required List visualNameList,
    @required int additionalCharLimit,
    bool isInputSubject = false,
  }) {
    itemList.insert(0, Center(child: Text("Choose below")));
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
                  if (value == 0) {
                  } else if (value == itemCount + 1) {
                    additionalTextField = true;
                    if (isInputSubject) {
                      sectionId = "";
                    }
                  } else {
                    textController.text = visualNameList[value - 1];
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
                  if (isInputSubject) {
                    sectionId = "";
                  }
                  textController.clear();
                  _showAdditionalTextField(
                      hintText: additionalPrompt,
                      textController: textController,
                      charLimit: additionalCharLimit);
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

  Future _showAdditionalTextField(
      {@required String hintText, @required TextEditingController textController, @required int charLimit}) {
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
                    child: taskTextFormField(hintText: hintText, textController: textController),
                  ),
                  SizedBox(height: 20),
                  ConfirmButton(
                    context: context,
                    onPress: () {
                      if (textController.text.length <= charLimit && textController.text.contains(letter26)) {
                        Navigator.popUntil(context, ModalRoute.withName(TaskScreenMaster.id));
                      } else {
                        NoticeDialog(context).showNoticeDialog(
                            title: "Invalid input",
                            bodyText: "The length over limit or it doesn't contain any letters",
                            isVibrate: true);
                        //TODO: shake interface
                      }
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
                      HomeworkType.sectionOnly: Text(
                        "Public",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      HomeworkType.singleStudentOnly: Text(
                        "Private",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      HomeworkType.fullyPublic: Text(
                        "All ⚠️",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    },
                  ),
                ),
              ),
              ExplanationText(
                  "️🔝 Click the help button located on top left ↖️ to get some sort of explanation️s"),
              taskTextFormField(
                  hintText: "Title (max $titleCharLimit letters)", textController: _titleController),
              SizedBox(
                height: 35,
                child: IOSStyleButton(
                    paddingValue: EdgeInsets.all(0),
                    buttonOnPress: _generateSubjectPicker,
                    primaryText: (sectionId == "")
                        ? ("Subject: ${_subjectController.text}")
                        : "Subject: ${_subjectController.text} sect.$sectionNumber",
                    secondaryText: _subjectController.text == "" ? "\tPress to choose" : null,
                    buttonColor: null,
                    primaryTextColor: Colors.black,
                    secondaryTextColor: Colors.black45),
              ),
              SizedBox(
                height: 35,
                child: IOSStyleButton(
                    paddingValue: EdgeInsets.all(0),
                    buttonOnPress: _generatePlatformPicker,
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
                    padding: EdgeInsets.only(left: 18),
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
                  hintText: "Note (optional && max $noteCharLimit letters)",
                  textController: _noteController,
                  maxLine: 3),
              if (taskType == HomeworkType.sectionOnly && isAdmin == false)
                ExplanationText(
                    "Your Public (students in same section can see) homework post will temporarily save as Private until admin approval"),
              if (taskType == HomeworkType.fullyPublic)
                ExplanationText(
                    "⚠️Warning⚠️\nThis homework will be seen by ALL student in CET program, if you only wish to let student in the same section to see please choose \"Public\" to add homework"),
              if (taskType == HomeworkType.fullyPublic && isAdmin == false)
                ExplanationText(
                    "And this homework post will temporarily save as Private until admin approval"),
              IOSStyleButton(
                  buttonOnPress: submitOnPress,
                  primaryText: taskType == HomeworkType.singleStudentOnly ? "Add" : "Post",
                  primaryTextColor: Colors.white),
              IOSStyleButton(
                  buttonOnPress: _cleanAllFields,
                  primaryText: 'Clean all inputs',
                  buttonColor: Colors.red,
                  primaryTextColor: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  void submitOnPress() {
    _isFormGood()
        ? _addHomework()
        : NoticeDialog(context)
            .showNoticeDialog(title: "Invalid input exist", bodyText: errorMessage, isVibrate: true);
  }

  bool _isFormGood() {
    int invalidCount = 0;
    bool isTitleOkay =
        _titleController.text.contains(letter26) && (_titleController.text.length <= titleCharLimit);
    bool isDatetimeAfter = _chosenDateTime.isAfter(DateTime.now());
    bool isNoteOkay = (_noteController.text.length <= noteCharLimit);
    List<bool> completenessList = [isTitleOkay, isDatetimeAfter, isNoteOkay];
    for (int i = 0; i < completenessList.length; i++) {
      if (!completenessList[i]) {
        invalidCount++;
        switch (i) {
          case 0:
            errorMessage = "Something wrong with title";
            break;
          case 3:
            errorMessage = "Something wrong with deadline";
            break;
          case 4:
            errorMessage = "Note length overflowed";
            break;
        }
      }
    }
    bool isFormCompleted = isTitleOkay && isDatetimeAfter;
    if (!isFormCompleted) {
      if (invalidCount > 1) {
        errorMessage = "More than one field is missing/wrong";
      }
    }
    return isFormCompleted;
  }

  Future _addHomework() async {
    Homework homework = Homework(
      studentId: uid,
      category: isAdmin ? taskType : HomeworkType.singleStudentOnly,
      targetCategory: isAdmin ? null : taskType,
      name: _titleController.text.trim(),
      subjectName: _subjectController.text.trim(),
      platformName: _whereController.text.trim(),
      where: submitPlatforms.keys
          .firstWhere((k) => submitPlatforms[k] == _whereController.text.trim(), orElse: () => null),
      note: _noteController.text.trim(),
      dueDate: _chosenDateTime,
      sectionId: sectionId,
    );

    if (homework.category == HomeworkType.singleStudentOnly) {
      Provider.of<DataService>(context, listen: false).addPrivateHomework(homework);
    } else {
      Provider.of<DataService>(context, listen: false).addPublicHomework(homework);
    }

    Provider.of<FirebaseService>(context, listen: false).uploadHomework(homework);
    NoticeDialog(context).showNoticeDialog(
        title: "This homework has been added", bodyText: "Current status: $taskType\nanimation constructing");
    _cleanAllFields();
  }

  void _cleanAllFields() {
    setState(() {
      sectionId = "";
      _titleController.clear();
      _noteController.clear();
      _whereController.clear();
      _subjectController.clear();
      dateTimeShown = dateFormat.format(DateTime.now());
      _chosenDateTime = DateTime.now();
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
          controller: textController,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
        ),
      ),
    );
  }
}
