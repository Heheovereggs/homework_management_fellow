import 'package:homework_management_fellow/model/section.dart';

class Subject {
  String id;
  String name;
  List<SubjectSection> sections = [];

  Subject({this.id, this.name, this.sections});
}
