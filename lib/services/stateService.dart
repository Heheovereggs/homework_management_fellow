import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/user.dart';

class StateService extends ChangeNotifier {
  User user;

  void setUser(User user) {
    this.user = user;
  }
}
