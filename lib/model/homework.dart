import 'package:flutter/material.dart';

class Homework {
  String docId;
  String category;
  String name;
  String sectionId;
  DateTime dueDate;
  String subjectName;
  String note;
  String where;
  String studentId;
  String targetCategory;
  String platformName;

  Homework(
      {this.docId,
      this.category,
      @required this.name,
      this.sectionId,
      @required this.dueDate,
      @required this.subjectName,
      this.note,
      @required this.where,
      this.studentId,
      this.targetCategory,
      this.platformName});
}

class HomeworkType {
  static const String singleStudentOnly = "singleStudentOnly";
  static const String sectionOnly = "sectionOnly";
  static const String fullyPublic = "fullyPublic";
}
