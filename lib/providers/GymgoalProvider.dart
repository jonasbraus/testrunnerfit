import 'package:flutter/material.dart';

class GymgoalProvider extends ChangeNotifier {
  static int goal = 2;

  void setGoal(int days) {
    goal = days;
    notifyListeners();
  }
}