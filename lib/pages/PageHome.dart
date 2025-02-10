import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/modules/CustomCircleDiagram.dart';
import 'package:fitflut/providers/GymgoalProvider.dart';
import 'package:fitflut/providers/LanguageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  String calcTimeFormat(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    return "$minutes min $seconds sec";
  }

  String formatTime(DateTime time) {
    String day =
        time.day.toString().length == 1 ? "0${time.day}" : "${time.day}";
    String month =
        time.month.toString().length == 1 ? "0${time.month}" : "${time.month}";
    String hour =
        time.hour.toString().length == 1 ? "0${time.hour}" : "${time.hour}";
    String minute = time.minute.toString().length == 1
        ? "0${time.minute}"
        : "${time.minute}";
    return "$day.$month $hour:$minute";
  }

  Future<List<int>> getWorkoutsLast7Days(DateTime now) async {
    List<int> output = [];

    for (int i = 0; i < 7; i++) {
      DateTime current = now.subtract(Duration(days: i));
      output.add(await DatabaseHelper.getWorkoutCountByDay(
          current.year, current.month, current.day));
    }

    return output;
  }

  Future<int> getWeeklyGymDays() async {
    DateTime endOfWeek =
        DateTime.now().add(Duration(days: 7 - DateTime.now().weekday));
    List<int> dailyWorkouts = await getWorkoutsLast7Days(endOfWeek);

    int output = 0;
    for (int i in dailyWorkouts) {
      if (i > 0) {
        output += 1;
      }
    }

    return output;
  }

  Widget buildWorkoutDays(
      BuildContext context, AsyncSnapshot<List<int>> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    DateTime now = DateTime.now();

    final weekdays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        for (int i = snapshot.data!.length - 1; i >= 0; i--)
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: (snapshot.data![i]).toDouble() * 20 + 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text(weekdays[now.subtract(Duration(days: i)).weekday - 1])
            ],
          )
      ],
    );
  }

  String getTimeDiffToString(DateTime current, DateTime past) {
    int timeSpan = current.difference(past).inDays;

    if (timeSpan > 1) {
      return LanguageProvider.lang == "en"
          ? "$timeSpan Days Ago"
          : "Vor $timeSpan Tagen";
    } else if (timeSpan > 0) {
      return LanguageProvider.lang == "en" ? "Yesterday" : "Gestern";
    }

    return LanguageProvider.lang == "en" ? "Today" : "Heute";
  }

  Widget buildLastWorkoutDisplay(
      BuildContext context, AsyncSnapshot<Map<String, Object?>> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    DateTime dt = snapshot.data!["time"] as DateTime;
    int duration = snapshot.data!["duration"] as int;
    String name = snapshot.data!["name"] as String;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text(calcTimeFormat(duration))
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 5),
                Text(getTimeDiffToString(DateTime.now(), dt))
              ],
            )
          ],
        )
      ],
    );
  }

  Widget buildCircleDiagram(BuildContext context, AsyncSnapshot<int> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    Color background = Theme.of(context).colorScheme.secondary.withAlpha(20);

    return CustomCircleDiagram(
      size: 90,
      backgroundColor: background,
      strokeColor: Theme.of(context).colorScheme.primary,
      max: GymgoalProvider.goal.toDouble(),
      value: snapshot.data!.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper.getLastWorkout();
    return FutureBuilder(
      future: getWorkoutsLast7Days(DateTime.now()),
      builder: (context, snapshot) => FutureBuilder(
        future: DatabaseHelper.getLastWorkout(),
        builder: (context, snapshot2) => SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              LanguageProvider.getMap()["home"]["welcome"],
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(20),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageProvider.getMap()["home"]["last7dayactivity"],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  buildWorkoutDays(context, snapshot)
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              LanguageProvider.getMap()["settings"]["gymgoal"],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            FutureBuilder(
              future: getWeeklyGymDays(),
              builder: (context, snapshot) => Consumer<GymgoalProvider>(
                builder: (context, goalProv, child) =>
                    buildCircleDiagram(context, snapshot),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(20),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LanguageProvider.getMap()["home"]["lastworkout"],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  buildLastWorkoutDisplay(context, snapshot2)
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
