import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/providers/RunningWorkoutProvider.dart';
import 'package:fitflut/providers/WorkoutPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';

import '../helpers/Workout.dart';
import '../providers/LanguageProvider.dart';

class PageWorkoutSummary extends StatelessWidget {
  const PageWorkoutSummary({super.key});

  String calcTimeFormat(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    return "$minutes min $seconds sec";
  }

  String formatTime(DateTime time) {
    return "${time.hour.toString().length == 1 ? '0${time.hour}' : time.hour.toString()}:${time.minute.toString().length == 1 ? '0${time.minute}' : time.minute}";
  }

  @override
  Widget build(BuildContext context) {
    int finishedEx = Provider.of<RunningWorkoutProvider>(context, listen: false)
        .getFinishedCount();
    int maxEx = Provider.of<WorkoutPageProvider>(context, listen: false)
        .workout!
        .exercises
        .length;

    Color exerciseColor = Colors.yellow;

    if (finishedEx <= 0) {
      exerciseColor = Theme.of(context).colorScheme.error;
    } else if (finishedEx >= maxEx) {
      exerciseColor = Colors.green;
    }

    return Consumer<RunningWorkoutProvider>(
      builder: (context, runningProv, child) => Consumer<WorkoutPageProvider>(
        builder: (context, pageProv, child) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/gym3.jpeg"),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withAlpha(150),
                              BlendMode.srcATop)),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      pageProv.workout!.name,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  LanguageProvider.getMap()["workouts"]["summary"],
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.timer),
                    SizedBox(width: 10),
                    Text(
                      calcTimeFormat(runningProv.durationSeconds),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: 10),
                        Text("Start"),
                        SizedBox(width: 10),
                        Text(
                          formatTime(runningProv.startTime),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month),
                        SizedBox(width: 10),
                        Text("End"),
                        SizedBox(width: 10),
                        Text(
                          formatTime(runningProv.endTime),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LanguageProvider.getMap()["workouts"]["finishedcount"],
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$finishedEx/$maxEx",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: exerciseColor),
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(25),
                borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
              ),
              child: FilledButton.icon(
                onPressed: () => {
                  DatabaseHelper.insertTrack(runningProv.durationSeconds,
                      runningProv.startTime, pageProv.workout!.id),
                  pageProv.selectPage(0, null)
                },
                icon: Icon(Icons.check),
                label: Text(LanguageProvider.getMap()["workouts"]["finish"]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
