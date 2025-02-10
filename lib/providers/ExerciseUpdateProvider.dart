import 'package:flutter/material.dart';

class ExerciseUpdateProvider extends ChangeNotifier {
  bool update = false;

  void updateState() {
    update = !update;
    notifyListeners();
  }
}