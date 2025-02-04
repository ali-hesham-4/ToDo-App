import 'package:flutter/material.dart';
import 'package:to_do_application/model/myUser.dart';

class AuthUserProvider extends ChangeNotifier {
  MyUser? currentUser;
  void updateUser(MyUser newUser) {
    currentUser = newUser;
    notifyListeners();
  }
}
