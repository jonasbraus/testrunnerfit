import 'dart:io';

import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:fitflut/helpers/Workout.dart';
import 'package:fitflut/helpers/WorkoutEditChange.dart';
import 'package:fitflut/helpers/WorkoutEditType.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late Database database;

  static Future<void> _createTableIfNotExists(
      String name, String createSt) async {
    var tableExists = await database.rawQuery(
        "select name from sqlite_master where type='table' and name=?", [name]);

    if (tableExists.isEmpty) {
      await database.execute(createSt);
    }
  }

  static Future<void> initDb() async {
    database = await openDatabase(
      join(await getDatabasesPath(), "workout_db.db"),
      onCreate: (db, version) {
        return db.execute(
            "create table exercise(id integer primary key, name text, weight int, bodyregion text);");
      },
      version: 1,
    );
    _createTableIfNotExists("exercise",
        "create table exercise(id integer primary key, name text, weight int, bodyregion text);");
    _createTableIfNotExists(
        "workout", "create table workout(id integer primary key, name text);");
    _createTableIfNotExists("workoutExercise",
        "create table workoutExercise(id integer primary key, workout_id int, exercise_id int);");
    _createTableIfNotExists("workoutTrack",
        "create table workoutTrack(id integer primary key, duration int, time Text, workout_id int);");
    _createTableIfNotExists("exerciseReps",
        "create table exerciseReps(id integer primary key, exercise_id int, rep1 int, rep2 int, rep3 int);");
  }

  static Future<Map<String, Object?>> getDBContents() async {
    Map<String, Object?> results = {};

    results["exercise"] = await database.query("exercise");
    results["workout"] = await database.query("workout");
    results["workoutExercise"] = await database.query("workoutExercise");
    results["workoutTrack"] = await database.query("workoutTrack");
    results["exerciseReps"] = await database.query("exerciseReps");

    return results;
  }

  static Future<void> insertMultiple(String table, List? content) async {
    if (content == null) {
      return;
    }

    for (var obj in content) {
      await database.insert(table, obj);
    }
  }

  static Future<void> setDBContents(Map<String, Object?> data) async {
    database.delete("exercise");
    database.delete("workout");
    database.delete("workoutExercise");
    database.delete("workoutTrack");
    database.delete("exerciseReps");

    insertMultiple("exercise", data["exercise"] as List?);
    insertMultiple("workout", data["workout"] as List?);
    insertMultiple("workoutExercise", data["workoutExercise"] as List?);
    insertMultiple("workoutTrack", data["workoutTrack"] as List?);
    insertMultiple("exerciseReps", data["exerciseReps"] as List?);
  }

  static Future<void> insertTrack(
      int duration, DateTime time, int workoutID) async {
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(time);
    await database.insert("workoutTrack",
        {"duration": duration, "time": formattedDate, "workout_id": workoutID});
  }

  static Future<int> getWorkoutCountByDay(int year, int month, int day) async {
    List<Map<String, Object?>> result = await database.query("workoutTrack");

    int output = 0;
    for (Map<String, Object?> map in result) {
      String timeStamp = map["time"] as String;
      DateTime dt = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(timeStamp);
      if (dt.day == day && dt.year == year && dt.month == month) {
        output += 1;
      }
    }

    return output;
  }

  static Future<Map<String, Object?>> getLastWorkout() async {
    List<Map<String, Object?>> result = await database.rawQuery(
        "select max(id) as 'id', duration, time, workout_id from workoutTrack");
    Map<String, Object?> lastWorkout = result.first;
    int id = lastWorkout["workout_id"] as int;
    DateTime dt = DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ')
        .parse(lastWorkout["time"] as String);
    int duration = lastWorkout["duration"] as int;
    List<Map<String, Object?>> workout_map =
        await database.query("workout", where: "id = ?", whereArgs: [id]);
    String name = workout_map.last["name"] as String;

    return {"time": dt, "duration": duration, "name": name};
  }

  static Future<void> insertExercise(Exercise exercise) async {
    await database.insert("exercise", exercise.toMap());
  }

  static Future<int> insertWorkout(Workout workout) async {
    await database.insert("workout", {"name": workout.name});

    List<Map<String, Object?>> idList =
        await database.rawQuery("select max(id) from workout");
    int workoutId = idList.first["max(id)"] as int;

    for (Exercise exercise in workout.exercises) {
      await database.insert("workoutExercise",
          {"workout_id": workoutId, "exercise_id": exercise.id});
    }

    return workoutId;
  }

  static Future<List<Workout>> getAllWorkouts() async {
    List<Map<String, Object?>> workoutMap = await database.rawQuery('''
        select workout.id as 'workoutID', workout.name as 'workoutName', exercise.id as 'exerciseID', exercise.name as 'exerciseName', exercise.weight, exercise.bodyregion 
        from workoutExercise
        inner join exercise on exercise.id = workoutExercise.exercise_id
        inner join workout on workout.id = workoutExercise.workout_id
        ''');

    Map<int, Workout> workoutObjects = {};
    for (Map<String, Object?> map in workoutMap) {
      int workoutId = map["workoutID"] as int;
      String workoutName = map["workoutName"] as String;
      int exerciseID = map["exerciseID"] as int;
      String exerciseName = map["exerciseName"] as String;
      int weight = map["weight"] as int;
      BodyRegions bodyRegion = {
        "BodyRegions.arms": BodyRegions.arms,
        "BodyRegions.stomach": BodyRegions.stomach,
        "BodyRegions.chest": BodyRegions.chest,
        "BodyRegions.fullBody": BodyRegions.fullBody,
        "BodyRegions.legs": BodyRegions.legs,
        "BodyRegions.back": BodyRegions.back
      }[map["bodyregion"]]!;

      if (!workoutObjects.keys.contains(workoutId)) {
        workoutObjects[workoutId] =
            Workout(id: workoutId, name: workoutName, exercises: []);
      }

      List<int> repsList = await getExerciseReps(exerciseID);

      workoutObjects[workoutId]!.exercises.add(
            Exercise(
              id: exerciseID,
              name: exerciseName,
              weight: weight,
              bodyRegion: bodyRegion,
              rep1: repsList[0],
              rep2: repsList[1],
              rep3: repsList[2]
            ),
          );
    }

    List<Workout> result = [];

    for (int key in workoutObjects.keys) {
      result.add(workoutObjects[key]!);
    }

    return result;
  }

  static Future<void> deleteWorkout(Workout workout) async {
    await database.delete("workout", where: "id = ?", whereArgs: [workout.id]);
    await database.delete("workoutExercise",
        where: "workout_id = ?", whereArgs: [workout.id]);
    await database.delete("workoutTrack",
        where: "workout_id = ?", whereArgs: [workout.id]);
  }

  static Future<void> updateWorkout(
      Workout workout, List<WorkoutEditChange> changes) async {
    await database.update("workout", workout.toMap(),
        where: "id = ?", whereArgs: [workout.id]);

    for (WorkoutEditChange change in changes) {
      if (change.type == WorkoutEditType.delete) {
        await database.delete("workoutExercise",
            where: "workout_id = ? and exercise_id = ?",
            whereArgs: [change.workoutId, change.exerciseId]);
      } else {
        await database.insert("workoutExercise",
            {"workout_id": change.workoutId, "exercise_id": change.exerciseId});
      }
    }
  }

  static Future<void> updateExercise(Exercise exercise) async {
    await database.update("exercise", exercise.toMap(),
        where: "id = ?", whereArgs: [exercise.id]);
    await database.delete("exerciseReps", where: "exercise_id = ?", whereArgs: [exercise.id]);
    await database.insert("exerciseReps", {
      "exercise_id": exercise.id,
      "rep1": exercise.rep1,
      "rep2": exercise.rep2,
      "rep3": exercise.rep3
    });
  }

  static Future<void> deleteExercise(Exercise exercise) async {
    await database
        .delete("exercise", where: "id = ?", whereArgs: [exercise.id]);
    await database.delete("workoutExercise",
        where: "exercise_id = ?", whereArgs: [exercise.id]);
    await database.delete("exerciseReps",
        where: "exercise_id = ?", whereArgs: [exercise.id]);
  }

  static Future<List<int>> getExerciseReps(int exercise_id) async {
    List<Map<String, Object?>> result = await database.query("exerciseReps",
        where: "exercise_id = ?", whereArgs: [exercise_id]);

    if (result.isNotEmpty) {
      return [
        result[0]["rep1"] as int,
        result[0]["rep2"] as int,
        result[0]["rep3"] as int
      ];
    }

    return [0, 0, 0];
  }

  static Future<List<Exercise>> getExercises(String filter) async {
    List<Map<String, Object?>> exerciseMap = await database.query("exercise");
    List<Exercise> exercises = [];

    for (Map<String, Object?> map in exerciseMap) {
      if ((map["bodyregion"] as String).split(".")[1] == filter ||
          filter == "") {

        List<int> reps = await getExerciseReps(map["id"] as int);

        exercises.add(
          Exercise(
              id: map["id"] as int,
              name: map["name"] as String,
              weight: map["weight"] as int,
              bodyRegion: {
                "BodyRegions.arms": BodyRegions.arms,
                "BodyRegions.stomach": BodyRegions.stomach,
                "BodyRegions.chest": BodyRegions.chest,
                "BodyRegions.fullBody": BodyRegions.fullBody,
                "BodyRegions.legs": BodyRegions.legs,
                "BodyRegions.back": BodyRegions.back
              }[map["bodyregion"]]!,
              rep1: reps[0],
              rep2: reps[1],
              rep3: reps[2]),
        );
      }
    }

    return exercises;
  }
}
