import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/student.dart';

class StateService extends ChangeNotifier {
  Student student;

  void setStudent(Student student) {
    this.student = student;
  }
}
