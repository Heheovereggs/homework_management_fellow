class Homework {
  late String docId;
  String category;
  String name;
  String sectionId;
  DateTime dueDate;
  String subjectName;
  String note;
  String? where;
  String studentId;
  String? targetCategory;
  String platformName;

  Homework(
      {required this.category,
      required this.name,
      required this.sectionId,
      required this.dueDate,
      required this.subjectName,
      required this.note,
      this.where,
      required this.studentId,
      this.targetCategory,
      required this.platformName});
}

class HomeworkType {
  static const String singleStudentOnly = "singleStudentOnly";
  static const String sectionOnly = "sectionOnly";
  static const String fullyPublic = "fullyPublic";
}
