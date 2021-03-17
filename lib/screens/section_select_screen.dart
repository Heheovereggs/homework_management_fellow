import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:homework_management_fellow/widgets/buttons.dart';
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
  DateFormat dateFormat = DateFormat("yyyy");
  String currentYear;
  String season;
  List<Subject> subjects = [];
  Map<String, String> sectionChoiceMap = {};
  Map<String, bool> subjectChoiceMap = {};

  @override
  void initState() {
    uid = Provider.of<DataService>(context, listen: false).student.uid;
    int currentMonth;
    currentYear = dateFormat.format(DateTime.now());
    currentMonth = DateTime.now().month;
    season = currentMonth >= 8 && currentMonth <= 12 ? "Autumn" : "Winter";
    getSubjectName();
    super.initState();
  }

  Future getSubjectName() async {
    subjects = await Provider.of<FirebaseService>(context, listen: false).getSubjectName();
    subjects.forEach((element) {
      //set each sectionId to the first one in the sections list
      sectionChoiceMap[element.id] = element.sections[0].id;

      subjectChoiceMap[element.id] = true;
    });
    setState(() {});
  }

  void _handleForm() {
    List<String> chosenSectionIds = [];
    for (String key in subjectChoiceMap.keys) {
      if (subjectChoiceMap[key] == true) {
        chosenSectionIds.add(sectionChoiceMap[key]);
      }
    }
    Student student = Student(sectionIds: chosenSectionIds, uid: uid);
    Provider.of<DataService>(context, listen: false).saveSections(student);
    Provider.of<FirebaseService>(context, listen: false).saveSectionIds(student);
    Navigator.pushNamed(context, '/ActivationPendingScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose sections ($season $currentYear)"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                    return sectionSelector(
                      subject: subjects[index],
                      isLast: isLast,
                      sectionChoiceMap: sectionChoiceMap,
                      subjectChoiceMap: subjectChoiceMap,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              IOSStyleButton(displayText: "Submit", buttonOnPress: _handleForm),
            ],
          ),
        ),
      ),
    );
  }

  Column sectionSelector({Subject subject, bool isLast, Map sectionChoiceMap, Map subjectChoiceMap}) {
    bool isParticipated = subjectChoiceMap[subject.id];

    Map<String, Widget> sliderItems =
        Map.fromIterable(subject.sections, key: (e) => e.id, value: (e) => Text(e.section));

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
                          subjectChoiceMap[subject.id] = value;
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
                      groupValue: sectionChoiceMap[subject.id],
                      onValueChanged: (value) {
                        setState(() {
                          sectionChoiceMap[subject.id] = value.toString();
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
}
