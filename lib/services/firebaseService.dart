import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  void saveLoginInfo({uid, email, firstName, lastName, isDiscord}) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('email', email);
    // prefs.setString('uid', uid);

    _firestore.collection('user').doc('$uid').set({
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'activate': false,
      'admin': false,
      'ban': false,
      'theme': null,
      'isDiscord': isDiscord
    });
  }
}
