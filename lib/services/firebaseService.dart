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
    var studentInfo = await _firestore.collection("student").doc(uid).get();
    print(email);
    print(studentInfo["uid"]);

    if (studentInfo["email"] == email) {
      student = Student(
          uid: studentInfo["uid"],
          email: studentInfo["email"],
          firstName: studentInfo["firstName"],
          lastName: studentInfo["lastName"],
          activate: studentInfo["activate"],
          admin: studentInfo["admin"],
          ban: studentInfo["ban"],
          theme: studentInfo["theme"],
          isDiscord: studentInfo["isDiscord"]);
    }

    return student;
  }
}
