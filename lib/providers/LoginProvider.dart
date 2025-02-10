import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier {
  static User? user;

  void logout() {
    user = null;
    notifyListeners();
  }

  void login(User u) {
    user = u;
    notifyListeners();
  }
}