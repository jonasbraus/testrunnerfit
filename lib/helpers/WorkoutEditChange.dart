import 'package:fitflut/helpers/WorkoutEditType.dart';

class WorkoutEditChange {
  int workoutId;
  int exerciseId;
  WorkoutEditType type;

  WorkoutEditChange({required this.workoutId, required this.exerciseId, required this.type});
}