import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataService extends ChangeNotifier {
  late Student student;
  List<Homework> privateHomeworkList = [];
  List<Homework> publicHomeworkList = [];
  bool isPrivateHomeworkLoaded = false;
  bool isPublicHomeworkLoaded = false;
  bool isShowAccessDenyDialogue = false;

  Future<void> setStudent(Student student) async {
    this.student = student;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', student.email);
    prefs.setString('uid', student.uid);
    prefs.setBool('isAdmin', student.admin);
    prefs.setBool('use24hFormat', student.use24HFormat);
  }

  Future<void> saveSections(sectionIds) async {
    student.sectionIds = sectionIds;
    student.activate = false;
  }

  void initializePrivateHomeworkList(List<Homework> homeworkList) {
    privateHomeworkList = homeworkList;
    isPrivateHomeworkLoaded = true;
    notifyListeners();
  }

  void initializePublicHomeworkList(List<Homework> blueHWList, List<Homework> greyHWList) {
    if (blueHWList.isNotEmpty) {
      publicHomeworkList = blueHWList;
      if (greyHWList.isNotEmpty) greyHWList.forEach((h) => publicHomeworkList.add(h));
    } else {
      publicHomeworkList = greyHWList;
    }
    isPublicHomeworkLoaded = true;
    notifyListeners();
  }

  void addPublicHomework(Homework homework) {
    publicHomeworkList.add(homework);
    notifyListeners();
  }

  void deletePublicHomework(Homework homework) {
    publicHomeworkList.remove(homework);
    notifyListeners();
  }

  void addPrivateHomework(Homework homework) {
    privateHomeworkList.add(homework);
    notifyListeners();
  }

  void deletePrivateHomework(Homework homework) {
    privateHomeworkList.remove(homework);
    notifyListeners();
  }

  void activateDialogue() {
    isShowAccessDenyDialogue = true;
    notifyListeners();
    Future.delayed(Duration(milliseconds: 1500), () {
      isShowAccessDenyDialogue = false;
      notifyListeners();
    });
  }
}
