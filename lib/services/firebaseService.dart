import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  void saveLoginInfo(Student user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user.email);
    prefs.setString('uid', user.uid);
    prefs.setBool('activate', user.activate);

    _firestore.collection('user').doc('${user.uid}').set({
      'uid': user.uid,
      'email': user.email,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'activate': false,
      'admin': false,
      'ban': false,
      'theme': null,
      'isDiscord': user.isDiscord
    });
  }

  Future<Student> checkUser({String email, String uid}) async {
    Student user;
    var userInfo = await _firestore.collection("user").where('email', isEqualTo: email).limit(1).get();
    for (var userInf in userInfo.docs) {
      if (userInf.data()["email"] == email) {
        user = Student(
            uid: userInf.data()["uid"],
            email: userInf.data()["email"],
            firstName: userInf.data()["firstName"],
            lastName: userInf.data()["lastName"],
            activate: userInf.data()["activate"],
            admin: userInf.data()["admin"],
            ban: userInf.data()["ban"],
            theme: userInf.data()["theme"],
            isDiscord: userInf.data()["isDiscord"]);
      }
    }

    return user;
  }
}
