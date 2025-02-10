import 'package:flutter/cupertino.dart';

import '../helpers/Workout.dart';

class WorkoutPageProvider extends ChangeNotifier {
  int selectedPage = 0;
  Workout? workout;

  void selectPage(int index, Workout? workout) {
    selectedPage = index;
    this.workout = workout;
    notifyListeners();
  }
}