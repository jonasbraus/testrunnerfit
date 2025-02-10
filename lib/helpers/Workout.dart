import 'package:fitflut/helpers/Exercise.dart';

class Workout {
  int id;
  String name;
  List<Exercise> exercises;

  Workout(
      {required this.id, required this.name, required this.exercises});

  Map<String, Object?> toMap() {
    return {
      "name": name,
    };
  }
}