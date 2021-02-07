class User {
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

  User({this.email, this.uid, this.firstName, this.lastName, this.isDiscord});
}
