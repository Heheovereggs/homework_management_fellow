import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/model/subject.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/dataService.dart';

class SectionSelectScreen extends StatefulWidget {
  @override
  _SectionSelectScreen createState() => _SectionSelectScreen();
}

class _SectionSelectScreen extends State<SectionSelectScreen> {
  String uid;
  String email;
  DateFormat dateFormat = DateFormat("yyyy");
  String currentYear;
  String season;
  List<Subject> subjects = [];
  Map<String, String> choiceMap = {};

  @override
  void initState() {
    int currentMonth;
    currentYear = dateFormat.format(DateTime.now());
    currentMonth = DateTime.now().month;
    season = currentMonth >= 8 && currentMonth <= 12 ? "Autumn" : "Winter";
    getSubjectName();
    super.initState();
  }

  Future getSubjectName() async {
    subjects = await Provider.of<FirebaseService>(context, listen: false).getSubjectName(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    email = Provider.of<DataService>(context, listen: false).student.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Choice sections ($season $currentYear)"),
        leading: Icon(Icons.arrow_back_ios_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(4),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: subjects.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isLast = false;
                    if (index + 1 == subjects.length) {
                      isLast = true;
                    }
                    return sectionSelector(subject: subjects[index], isLast: isLast);
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(19),
                child: SizedBox(
                  width: 350,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF2196f3),
                    child: Text(
                      'Submit',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                    ),
                    onPressed: _saveSectionIds,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column sectionSelector({Subject subject, bool isLast}) {
    bool isParticipated = true;
    String subjectId = subject.id;
    String choice = "1";

    Map<String, Widget> sliderItems =
        Map.fromIterable(subject.sections, key: (e) => e.section, value: (e) => Text(e.section));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do you have ${subject.name} course?",
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                height: 35,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      value: isParticipated,
                      items: [
                        DropdownMenuItem(child: Text("Yes"), value: true),
                        DropdownMenuItem(child: Text("No"), value: false),
                      ],
                      onChanged: (value) {
                        setState(() {
                          isParticipated = value;
                        });
                      }),
                ),
              ),
            )
          ],
        ),
        isParticipated
            ? Column(
                children: [
                  Text("Your section:"),
                  SizedBox(height: 8),
                  Container(
                    width: 335,
                    child: CupertinoSlidingSegmentedControl(
                      thumbColor: Color(0xFF2196f3),
                      groupValue: choice,
                      onValueChanged: (value) {
                        setState(() {
                          choice = value;
                          choiceMap[subjectId] = choice;
                        });
                      },
                      children: sliderItems,
                    ),
                  ),
                ],
              )
            : Container(),
        isLast ? Container() : Text("-----------------------------------------"),
      ],
    );
  }

  void _saveSectionIds() {
    print(choiceMap);
    // List<String> sectionIds = Provider.of<DataService>(context, listen: false).setSections(choiceMap);
    // Student student = Student(sectionIds: sectionIds);
    // Provider.of<FirebaseService>(context, listen: false).saveSectionIds(student);
    // Navigator.pushNamed(context, '/ActivationPendingScreen');
  }
}
