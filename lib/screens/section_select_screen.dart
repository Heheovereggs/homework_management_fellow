import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:provider/provider.dart';

class SectionSelectScreen extends StatefulWidget {
  @override
  _SectionSelectScreen createState() => _SectionSelectScreen();
}

class _SectionSelectScreen extends State<SectionSelectScreen> {
  String uid;
  String email;
  Map subjectNameMap;
  Map subjectIdsMap;

  @override
  void initState() {
    getSubjectMap();
    super.initState();
  }

  Future getSubjectMap() async {
    subjectNameMap = await Provider.of<FirebaseService>(context, listen: false).getSubjectMap();
    subjectIdsMap = subjectNameMap;
    for (var i in subjectIdsMap.values) {
      i = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    email = arguments['email'];
    uid = arguments['uid'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        leading: Icon(Icons.arrow_back_ios_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  "Your email: $email",
                  style: TextStyle(fontSize: 24, height: 1.3),
                ),
              ),
              ListView.builder(
                itemCount: subjectNameMap.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = subjectNameMap.keys.elementAt(index);
                  return sectionSelector(
                      subjectName: subjectNameMap[key], subjectId: key, sectionNumber: );
                },
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

  Padding sectionSelector({String subjectId, int sectionNumber, String subjectName}) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$subjectName",
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
                    value: sectionNumber,
                    items: [
                      DropdownMenuItem(child: Text("-"), value: 0),
                      DropdownMenuItem(child: Text("1"), value: 1),
                      DropdownMenuItem(child: Text("2"), value: 2),
                      DropdownMenuItem(child: Text("2"), value: 3),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sectionNumber = value;
                      });
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
