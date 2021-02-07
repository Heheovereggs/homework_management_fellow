import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/model/student.dart';

class StateService extends ChangeNotifier {
  Student student;
  List<Homework> publicHomeworkList = [];

  void setStudent(Student student) {
    this.student = student;
  }

  void setPublicHomeworkList(List<Homework> homeworkList) {
    publicHomeworkList = homeworkList;
    notifyListeners();
  }
}
