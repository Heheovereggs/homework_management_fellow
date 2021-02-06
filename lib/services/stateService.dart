import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/user.dart';

class StateService extends ChangeNotifier {
  User user = User(email: '33@dd.cc', uid: 'xxxx', firstName: 'Wuyang', lastName: 'Wu');
}
