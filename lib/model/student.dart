class Student {
  String uid;
  String email;
  String firstName;
  String lastName;
  bool activate;
  bool admin;
  bool ban;
  DateTime dateOfJoin;
  String? theme;
  List? sectionIds;
  bool use24HFormat;

  Student(
      {required this.email,
      required this.uid,
      required this.firstName,
      required this.lastName,
      required this.admin,
      required this.activate,
      required this.ban,
      required this.dateOfJoin,
      required this.theme,
      this.sectionIds,
      this.use24HFormat = true});
}
