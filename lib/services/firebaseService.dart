import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homework_management_fellow/model/user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  void saveLoginInfo(User user) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', email);
    // prefs.setString('uid', uid);

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
}
