import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  void saveLoginInfo(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', student.email);
    prefs.setString('uid', student.uid);
    prefs.setBool('activate', student.activate);

    _firestore.collection('student').doc('${student.uid}').set({
      'uid': student.uid,
      'email': student.email,
      'firstName': student.firstName,
      'lastName': student.lastName,
      'activate': false,
      'admin': false,
      'ban': false,
      'theme': null,
      'isDiscord': student.isDiscord
    });
  }

  Future<Student> checkStudent({String email, String uid}) async {
    Student student;
    var studentInfo =
        await _firestore.collection("student").where('email', isEqualTo: email).limit(1).get();
    print(email);
    print(studentInfo.docs);
    for (var studentInf in studentInfo.docs) {
      if (studentInf.data()["email"] == email) {
        student = Student(
            uid: studentInf.data()["uid"],
            email: studentInf.data()["email"],
            firstName: studentInf.data()["firstName"],
            lastName: studentInf.data()["lastName"],
            activate: studentInf.data()["activate"],
            admin: studentInf.data()["admin"],
            ban: studentInf.data()["ban"],
            theme: studentInf.data()["theme"],
            isDiscord: studentInf.data()["isDiscord"]);
      }
    }
    return student;
  }
}
