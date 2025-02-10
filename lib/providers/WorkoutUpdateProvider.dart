import 'package:flutter/material.dart';

class WorkoutUpdateProvider extends ChangeNotifier {
  bool update = false;

  void updateState() {
    update = !update;
    notifyListeners();
  }
}