import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/student.dart';

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

  Future<Map> getSubjectMap() async {
    print("==================~~~>");
    Map<String, String> subjectMap;
    var subjects = await _firestore.collection("subject").get();
    for (var subject in subjects.docs) {
      subjectMap[subject.id] = subject["name"];
    }
    print("==================~~~>");
    print(subjectMap);
    return subjectMap;
  }
}
