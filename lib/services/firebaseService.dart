import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/model/subject.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dataService.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  void saveLoginInfo(Student student) async {
    _firestore.collection('student').doc(student.uid).set({
      'uid': student.uid,
      'email': student.email,
      'firstName': student.firstName,
      'lastName': student.lastName,
      'activate': false,
      'admin': false,
      'ban': false,
      'theme': null,
      'isDiscord': student.isDiscord,
      'sectionIds': student.sectionIds,
      'use24hFormat': student.use24HFormat,
    });
  }

  Future<Student> checkStudent({String email, String uid}) async {
    Student student;
    print(email);
    print(uid);

    var studentInfo = await _firestore.collection("student").doc("$uid").get();

    if (studentInfo.exists && studentInfo["email"] == email) {
      student = Student(
          uid: studentInfo["uid"],
          email: studentInfo["email"],
          firstName: studentInfo["firstName"],
          lastName: studentInfo["lastName"],
          activate: studentInfo["activate"],
          admin: studentInfo["admin"],
          ban: studentInfo["ban"],
          theme: studentInfo["theme"],
          isDiscord: studentInfo["isDiscord"],
          sectionIds: studentInfo["sectionIds"],
          use24HFormat: studentInfo["use24hFormat"]);
    }
    return student;
  }

  Future<List<Homework>> getPublicHomeWorkList(List studentSectionIds) async {
    Map submitPlatforms = await getSubmitPlatform();
    List<Homework> homeworkList = [];
    print('pull from firebase');
    QuerySnapshot qnSection = await _firestore
        .collection('homework')
        .where('category', isEqualTo: HomeworkType.sectionOnly)
        .orderBy('dueDate')
        .get();
    for (DocumentSnapshot doc in qnSection.docs) {
      if (studentSectionIds.contains(doc['sectionId'])) {
        homeworkList.add(Homework(
            docId: doc.id,
            dueDate: doc['dueDate'].toDate(),
            name: doc['name'],
            note: doc['note'],
            subjectName: doc['subjectName'],
            where: submitPlatforms[doc['where']],
            isWaiting: doc['isWaiting'],
            platformName: doc['platformName']));
      }
    }
    QuerySnapshot qnAll = await _firestore
        .collection('homework')
        .where('category', isEqualTo: HomeworkType.fullyPublic)
        .orderBy('dueDate')
        .get();
    for (DocumentSnapshot doc in qnAll.docs) {
      homeworkList.add(Homework(
          docId: doc.id,
          dueDate: doc['dueDate'].toDate(),
          name: doc['name'],
          note: doc['note'],
          subjectName: doc['subjectName'],
          where: submitPlatforms[doc['where']],
          isWaiting: doc['isWaiting'],
          platformName: doc['platformName']));
    }
    homeworkList.sort((a, b) {
      return a.dueDate.compareTo(b.dueDate);
    });
    return homeworkList;
  }

  Future<Map> getSubmitPlatform() async {
    Map submitPlatform = {};
    QuerySnapshot qn = await _firestore.collection('submitPlatform').get();
    for (DocumentSnapshot doc in qn.docs) {
      submitPlatform[doc.id] = doc["name"];
    }
    return submitPlatform;
  }

  Future uploadHomework(Homework homework) async {
    _firestore.collection('homework').add({
      "category": homework.category,
      "name": homework.name,
      "dueDate": homework.dueDate,
      "isWaiting": homework.isWaiting,
      "note": homework.note,
      "sectionId": homework.sectionId,
      "studentId": homework.studentId,
      "subjectName": homework.subjectName,
      "where": homework.where,
      "platformName": homework.platformName,
    });
  }

  Future deleteHomework({Homework homework, bool isPrivate = false, context}) async {
    if (isPrivate) {
      _firestore.collection('homework').doc(homework.docId).delete();
    } else {
      final prefs = await SharedPreferences.getInstance();
      bool isAdmin = prefs.getBool('isAdmin');
      if (isAdmin) {
        _firestore.collection('homework').doc(homework.docId).delete();
      } else {
        Provider.of<DataService>(context, listen: false).activateDialogue();
      }
    }
  }

  Future<List<Homework>> getPrivateHomeWorkList(String uid) async {
    List<Homework> homeworkList = [];
    print('pull private tasks from firebase');
    QuerySnapshot qn =
        await _firestore.collection('homework').where('studentId', isEqualTo: uid).orderBy('dueDate').get();
    for (DocumentSnapshot doc in qn.docs) {
      if (doc["category"] == HomeworkType.singleStudentOnly) {
        homeworkList.add(Homework(
            docId: doc.id,
            dueDate: doc['dueDate'].toDate(),
            name: doc['name'],
            note: doc['note'],
            subjectName: doc['subjectName'],
            studentId: doc['studentId'],
            where: doc['where'],
            isWaiting: doc['isWaiting'],
            platformName: doc['platformName']));
      }
    }
    return homeworkList;
  }

  Future<List<Subject>> getSubjectList() async {
    List<SubjectSection> sections = await getSections();
    List<Subject> subjects = [];
    var qn = await _firestore.collection("subject").orderBy("name").get();
    for (var subject in qn.docs) {
      List<SubjectSection> thisSections =
          sections.where((element) => element.subjectId == subject.id).toList();
      subjects.add(Subject(
        id: subject.id,
        name: subject["name"],
        sections: thisSections,
      ));
    }
    return subjects;
  }

  Future<List<SubjectSection>> getSections({String subjectId}) async {
    List<SubjectSection> sections = [];
    var qn = (subjectId != null)
        ? await _firestore.collection("section").where("subjectId", isEqualTo: subjectId).get()
        : await _firestore.collection("section").orderBy("section").get();
    for (var section in qn.docs) {
      sections
          .add(SubjectSection(id: section.id, section: section["section"], subjectId: section["subjectId"]));
    }

    return sections;
  }

  void saveSectionIds(Student student) async {
    _firestore.collection('student').doc(student.uid).update({'sectionIds': student.sectionIds});
  }

  //TODO: to be tested
  void saveHourFormat(Student student) async {
    _firestore.collection('student').doc(student.uid).update({'use24hFormat': student.use24HFormat});
  }
}
