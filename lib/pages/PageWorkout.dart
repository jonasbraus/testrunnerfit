import 'dart:math';

import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/modules/WorkoutTask.dart';
import 'package:fitflut/providers/LanguageProvider.dart';
import 'package:fitflut/providers/RunningWorkoutProvider.dart';
import 'package:fitflut/providers/WorkoutPageProvider.dart';
import 'package:fitflut/providers/WorkoutUpdateProvider.dart';
import 'package:fitflut/workoutPages/PageWorkoutAdd.dart';
import 'package:fitflut/workoutPages/PageWorkoutEdit.dart';
import 'package:fitflut/workoutPages/PageWorkoutSummary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/Workout.dart';

class PageWorkout extends StatelessWidget {
  const PageWorkout({super.key});

  Future<List<Workout>> getAllWorkouts() async {
    List<Workout> output = await DatabaseHelper.getAllWorkouts();
    return output;
  }

  List<Widget> buildBodyContent(
      AsyncSnapshot<List<Workout>> snapshot, BuildContext context) {
    if (snapshot.data == null) {
      return [Container()];
    }

    List<Widget> result = [
      for (Workout workout in snapshot.data!)
        GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PageWorkoutEdit(
                workout: workout,
              ),
            ));
          },
          onTap: () {
            Provider.of<RunningWorkoutProvider>(context, listen: false)
                .clearCheckboxes();
            Provider.of<WorkoutPageProvider>(context, listen: false)
                .selectPage(1, workout);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 10, left: 5, right: 5),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/gym3.jpeg",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.surface.withAlpha(150),
                        BlendMode.srcATop)),
                borderRadius: BorderRadius.circular(15)),
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        workout.name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${workout.exercises.length} ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          LanguageProvider.getMap()["workouts"]["exercises"],
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
                Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.primary,)
              ],
            ),),
          ),
        )
    ];

    return result;
  }

  Widget mainPage(BuildContext context) {
    return Consumer<WorkoutUpdateProvider>(
      builder: (context, value, child) => FutureBuilder(
        future: getAllWorkouts(),
        builder: (context, snapshot) => Container(
          // EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 10)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          for (Widget w in buildBodyContent(snapshot, context))
                            w,
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(25),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 0),
                  child: FilledButton.icon(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PageWorkoutAdd(),
                      ))
                    },
                    label: Text(
                        LanguageProvider.getMap()["workouts"]["newworkout"]),
                    icon: Icon(Icons.add_rounded),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutPageProvider>(
      builder: (context, value, child) => {
        0: mainPage(context),
        1: WorkoutTask(),
        2: PageWorkoutSummary()
      }[value.selectedPage]!,
    );
  }
}
