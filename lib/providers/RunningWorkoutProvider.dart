import 'dart:async';

import 'package:flutter/material.dart';

class RunningWorkoutProvider extends ChangeNotifier {
  bool running = false;
  List<bool> checkedValues = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  Timer? timer;
  int durationSeconds = 0;
  bool paused = false;

  void clearCheckboxes() {
    checkedValues = [for(int i = 0; i < 1000; i++) false];
    running = false;
    paused = false;
    durationSeconds = 0;
    notifyListeners();
  }

  void updateCheckboxAt(int index, bool value, BuildContext context) {
    if (!running) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please start workout first!")));
      return;
    }
    paused = false;
    checkedValues[index] = value;
    notifyListeners();
  }

  void start() {
    running = true;
    paused = false;
    notifyListeners();
    startTime = DateTime.now();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      durationSeconds = DateTime.now().difference(startTime).inSeconds;
      notifyListeners();
    },);
  }

  void resume() {
    running = true;
    paused = false;

    notifyListeners();

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      durationSeconds = DateTime.now().difference(startTime).inSeconds;
      notifyListeners();
    },);
  }

  void stop() {
    running = false;
    timer!.cancel();
    endTime = DateTime.now();
    notifyListeners();
  }

  void pause() {
    paused = true;
    running = false;
    timer!.cancel();
    notifyListeners();
  }

  int getFinishedCount() {
    int count = 0;
    for (bool value in checkedValues) {
      if (value) {
        count += 1;
      }
    }
    return count;
  }
}