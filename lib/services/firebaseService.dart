import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataService.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/model/subject.dart';
import 'package:provider/provider.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  void saveLoginInfo(Student student) async {
    _firestore.collection('student').doc('${student.uid}').set({
      'uid': student.uid,
      'email': student.email,
      'firstName': student.firstName,
      'lastName': student.lastName,
      'activate': false,
      'admin': false,
      'ban': false,
      'theme': null,
      'isDiscord': student.isDiscord,
      'sectionIds': student.sectionIds
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
          sectionIds: studentInfo["sectionIds"]);
    }
    return student;
  }

  Future<List<Homework>> getPublicHomeWorkList(String uid) async {
    List<Homework> homeworkList = [];
    print('pull from firebase');
    QuerySnapshot qn =
        await _firestore.collection('homework').where('studentId', isEqualTo: '').orderBy('dueDate').get();
    for (DocumentSnapshot doc in qn.docs) {
      homeworkList.add(Homework(
          dueDate: doc['dueDate'].toDate(),
          name: doc['name'],
          note: doc['note'],
          subject: doc['subject'],
          studentId: doc['studentId'],
          where: doc['where'],
          isWaiting: doc['isWaiting']));
    }
    return homeworkList;
  }

  Future<List<Homework>> getPrivateHomeWorkList(String uid) async {
    List<Homework> homeworkList = [];
    print('pull private tasks from firebase');
    QuerySnapshot qn =
        await _firestore.collection('homework').where('studentId', isEqualTo: uid).orderBy('dueDate').get();
    for (DocumentSnapshot doc in qn.docs) {
      homeworkList.add(Homework(
          dueDate: doc['dueDate'].toDate(),
          name: doc['name'],
          note: doc['note'],
          subject: doc['subject'],
          studentId: doc['studentId'],
          where: doc['where'],
          isWaiting: doc['isWaiting']));
    }
    return homeworkList;
  }

  Future<List<Subject>> getSubjectName(context) async {
    List<SubjectSection> sections = await getSections(context);
    List<Subject> subjects = [];
    var qn = await _firestore.collection("subject").get();
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

  Future<List<SubjectSection>> getSections(context) async {
    List<SubjectSection> sections = [];
    var qn = await _firestore.collection("section").orderBy("section").get();
    for (var section in qn.docs) {
      sections
          .add(SubjectSection(id: section.id, section: section["section"], subjectId: section["subjectId"]));
    }
    Provider.of<DataService>(context, listen: false).setSectionSummary(sections);
    return sections;
  }

  void saveSectionIds(Student student) async {
    _firestore.collection('student').doc('${student.uid}').set({'sectionIds': student.sectionIds});
  }
}
