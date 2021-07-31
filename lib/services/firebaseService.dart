import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/model/subject.dart';
import 'package:provider/provider.dart';
import 'dataService.dart';

class FirebaseService {
  List<Homework> _homeworkList = [];
  List<Homework> _outDatedHomeworkList = [];
  List<SubjectSection> _sections = [];
  List<Subject> _subjects = [];
  Map<String, String> _submitPlatform = {};
  Student? _student;

  Student? getStudent() => _student;
  List<Homework> getHomeworkList() => _homeworkList;
  List<Homework> getOutDatedHomeworkList() => _outDatedHomeworkList;
  List<Subject> getSubjects() => _subjects;
  List<SubjectSection> getSections() => _sections;
  Map<String, String> getSubmitPlatform() => _submitPlatform;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void saveLoginInfo(Student student) async {
    _firestore.collection('student').doc(student.uid).set({
      'uid': student.uid,
      'email': student.email,
      'firstName': student.firstName,
      'lastName': student.lastName,
      'activate': false,
      'admin': false,
      'ban': student.ban,
      'theme': student.theme,
      'sectionIds': student.sectionIds,
      'use24hFormat': student.use24HFormat,
      'dateOfJoin': Timestamp.fromDate(student.dateOfJoin),
    });
  }

  Future<bool> checkStudent({String? email, String? uid}) async {
    print(email);
    print(uid);

    var studentInfo = await _firestore.collection("student").doc("$uid").get();

    if (studentInfo.exists && studentInfo["email"] == email) {
      _student = Student(
          uid: studentInfo["uid"],
          email: studentInfo["email"],
          firstName: studentInfo["firstName"],
          lastName: studentInfo["lastName"],
          activate: studentInfo["activate"],
          admin: studentInfo["admin"],
          ban: studentInfo["ban"],
          theme: studentInfo["theme"],
          sectionIds: studentInfo["sectionIds"],
          use24HFormat: studentInfo["use24hFormat"],
          dateOfJoin: studentInfo["dateOfJoin"].toDate());
      if (_student!.activate)
        return true;
      else
        return false;
    }
    return false;
  }

  Future getPublicHomeWorkList(List? studentSectionIds) async {
    await loadSubmitPlatform();
    print('pull from firebase');
    QuerySnapshot qnSection = await _firestore
        .collection('homework')
        .where('category', isEqualTo: HomeworkType.sectionOnly)
        .orderBy('dueDate')
        .get();
    for (DocumentSnapshot doc in qnSection.docs) {
      if (studentSectionIds!.contains(doc['sectionId'])) {
        Homework homework = Homework(
            dueDate: doc['dueDate'].toDate(),
            name: doc['name'],
            note: doc['note'],
            subjectName: doc['subjectName'],
            where: _submitPlatform[doc['where']],
            targetCategory: doc['targetCategory'],
            platformName: doc['platformName'],
            studentId: doc['studentId'],
            sectionId: doc['sectionId'],
            category: doc['category']);
        homework.docId = doc.id;
        if (homework.dueDate.isAfter(DateTime.now()))
          _homeworkList.add(homework);
        else
          _outDatedHomeworkList.add(homework);
      }
    }
    QuerySnapshot qnAll = await _firestore
        .collection('homework')
        .where('category', isEqualTo: HomeworkType.fullyPublic)
        .orderBy('dueDate')
        .get();
    for (DocumentSnapshot doc in qnAll.docs) {
      Homework homework = Homework(
          dueDate: doc['dueDate'].toDate(),
          name: doc['name'],
          note: doc['note'],
          subjectName: doc['subjectName'],
          where: _submitPlatform[doc['where']],
          targetCategory: doc['targetCategory'],
          platformName: doc['platformName'],
          studentId: doc['studentId'],
          sectionId: doc['sectionId'],
          category: doc['category']);
      homework.docId = doc.id;
      if (homework.dueDate.isAfter(DateTime.now()))
        _homeworkList.add(homework);
      else
        _outDatedHomeworkList.add(homework);
    }
    _homeworkList.sort((a, b) {
      return a.dueDate.compareTo(b.dueDate);
    });
    _outDatedHomeworkList.sort((a, b) {
      return a.dueDate.compareTo(b.dueDate);
    });
  }

  Future loadSubmitPlatform() async {
    QuerySnapshot qn = await _firestore.collection('submitPlatform').get();
    for (DocumentSnapshot doc in qn.docs) {
      _submitPlatform[doc.id] = doc["name"];
    }
  }

  Future uploadHomework(Homework homework) async {
    _firestore.collection('homework').add({
      "category": homework.category,
      "name": homework.name,
      "dueDate": homework.dueDate,
      "targetCategory": homework.targetCategory,
      "note": homework.note,
      "sectionId": homework.sectionId,
      "studentId": homework.studentId,
      "subjectName": homework.subjectName,
      "where": homework.where,
      "platformName": homework.platformName,
    });
  }

  Future deleteHomework(Homework homework, context) async {
    if (homework.category == HomeworkType.singleStudentOnly) {
      await _firestore.collection('homework').doc(homework.docId).delete();
      Provider.of<DataService>(context, listen: false).deletePrivateHomework(homework);
    } else {
      bool _isAdmin = Provider.of<DataService>(context, listen: false).student.admin;
      if (_isAdmin) {
        await _firestore.collection('homework').doc(homework.docId).delete();
        Provider.of<DataService>(context, listen: false).deletePublicHomework(homework);
      } else {
        Provider.of<DataService>(context, listen: false).activateDialogue();
      }
    }
  }

  Future loadPrivateHomeWorkList(String? uid) async {
    print('pull private tasks from firebase');
    QuerySnapshot qn =
        await _firestore.collection('homework').where('studentId', isEqualTo: uid).orderBy('dueDate').get();
    for (DocumentSnapshot doc in qn.docs) {
      if (doc["category"] == HomeworkType.singleStudentOnly) {
        Homework homework = Homework(
            dueDate: doc['dueDate'].toDate(),
            name: doc['name'],
            note: doc['note'],
            subjectName: doc['subjectName'],
            targetCategory: doc['targetCategory'],
            platformName: doc['platformName'],
            studentId: doc['studentId'],
            sectionId: doc['sectionId'],
            category: doc['category']);
        homework.docId = doc.id;
        _homeworkList.add(homework);
      }
    }
  }

  Future loadSubjectList() async {
    await loadSections();
    var qn = await _firestore.collection("subject").orderBy("name").get();
    for (var subject in qn.docs) {
      List<SubjectSection> thisSections =
          _sections.where((element) => element.subjectId == subject.id).toList();
      _subjects.add(Subject(
        id: subject.id,
        name: subject["name"],
        sections: thisSections,
      ));
    }
  }

  Future loadSections({String? subjectId}) async {
    var qn = (subjectId != null)
        ? await _firestore.collection("section").where("subjectId", isEqualTo: subjectId).get()
        : await _firestore.collection("section").orderBy("section").get();
    for (var section in qn.docs) {
      _sections
          .add(SubjectSection(id: section.id, section: section["section"], subjectId: section["subjectId"]));
    }
  }

  void saveSectionIds(String uid, List sectionIds) async {
    _firestore.collection('student').doc(uid).update({'sectionIds': sectionIds, 'activate': false});
  }

  //TODO: to be tested
  void saveHourFormat(Student student) async {
    _firestore.collection('student').doc(student.uid).update({'use24hFormat': student.use24HFormat});
  }
}
