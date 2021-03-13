class Student {
  String uid;
  String email;
  String firstName;
  String lastName;
  bool activate;
  bool admin;
  bool ban;
  DateTime dateOfJoin;
  String theme;
  bool isDiscord;
  List sectionIds;

  Student(
      {this.email,
      this.uid,
      this.firstName,
      this.lastName,
      this.isDiscord,
      this.admin,
      this.activate,
      this.ban,
      this.dateOfJoin,
      this.theme,
      this.sectionIds});
}
