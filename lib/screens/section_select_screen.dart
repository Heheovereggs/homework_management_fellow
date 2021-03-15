import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/section.dart';
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
  List<Subject> subjects = [];

  @override
  void initState() {
    getSubjectMap();
    super.initState();
  }

  Future getSubjectMap() async {
    subjects = await Provider.of<FirebaseService>(context, listen: false).getSubjectMap();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    email = Provider.of<DataService>(context, listen: false).student.email;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        leading: Icon(Icons.arrow_back_ios_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (BuildContext context, int index) {
                    return sectionSelector(subject: subjects[index]);
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
                    onPressed: _saveSections,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding sectionSelector({Subject subject}) {
    List<DropdownMenuItem> listDropdown = subject.sections
        .map((e) => DropdownMenuItem(
              child: Text(e.section),
              value: e.section,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${subject.name}",
            style: TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    value: "-",
                    items: listDropdown,
                    onChanged: (value) {
                      setState(() {});
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveSections() {
    Student student = Student(sectionIds: []);

    // save to provider StateService
    Provider.of<DataService>(context, listen: false).setStudent(student);

    // save to firebase
    Provider.of<FirebaseService>(context, listen: false).saveLoginInfo(student);
    Navigator.pushNamed(context, '/ActivationPendingScreen');
  }
}
