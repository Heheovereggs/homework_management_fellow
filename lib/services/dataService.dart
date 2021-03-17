import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/section.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService extends ChangeNotifier {
  Student student;
  List<Homework> privateHomeworkList = [];
  bool isHomeworkListLoaded = false;

  Future<void> setStudent(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', student.email);
    prefs.setString('uid', student.uid);
    this.student = student;
  }

  Future<void> saveSections(Student student) async {
    this.student.sectionIds = student.sectionIds;
  }

  void setPrivateHomeworkList(List<Homework> homeworkList) {
    privateHomeworkList = homeworkList;
    isHomeworkListLoaded = true;
    notifyListeners();
  }

  void addPrivateHomework(Homework homework) {
    privateHomeworkList.add(homework);
    notifyListeners();
  }
}
