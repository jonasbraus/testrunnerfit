import 'package:fitflut/helpers/Workout.dart';
import 'package:fitflut/providers/RunningWorkoutProvider.dart';
import 'package:fitflut/providers/WorkoutPageProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/Exercise.dart';
import '../providers/LanguageProvider.dart';

class WorkoutTask extends StatelessWidget {
  const WorkoutTask({super.key});

  Widget buildExerciseCheckbox(int index, Exercise exercise, Workout workout,
      RunningWorkoutProvider prov, BuildContext context) {
    return Column(
      children: [
        FilledButton(
          style: ButtonStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromARGB(10, 255, 255, 255)),
              padding: WidgetStatePropertyAll(
                  EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20))),
          onPressed: () => {
            prov.updateCheckboxAt(index, !prov.checkedValues[index], context)
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: prov.checkedValues[index],
                    onChanged: (value) =>
                        prov.updateCheckboxAt(index, value!, context),
                  ),
                  Text(
                    exercise.name,
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "${exercise.rep1}-${exercise.rep2}-${exercise.rep3}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.heart_broken_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "${exercise.weight} kg",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  String calcTimeFormat(int seconds) {
    int minutes = seconds ~/ 60;
    seconds = seconds % 60;

    return "$minutes min $seconds sec";
  }

  @override
  Widget build(BuildContext context) {
    Workout workout =
        Provider.of<WorkoutPageProvider>(context, listen: false).workout!;

    return Consumer<RunningWorkoutProvider>(
      builder: (context, prov, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
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
                    workout.name,
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer),
                  SizedBox(width: 10),
                  Text(
                    calcTimeFormat(prov.durationSeconds),
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    for (int i = 0; i < workout.exercises.length; i++)
                      buildExerciseCheckbox(
                          i, workout.exercises[i], workout, prov, context)
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(25),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: {
              false: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () => {
                        Provider.of<WorkoutPageProvider>(context, listen: false)
                            .selectPage(0, null)
                      },
                      label:
                          Text(LanguageProvider.getMap()["workouts"]["back"]),
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => {prov.start()},
                      label: Text("Start"),
                      icon: Icon(Icons.play_arrow),
                    ),
                  ),
                ],
              ),
              true: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: FilledButton.icon(
                        onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              contentPadding:
                                  EdgeInsets.only(top: 18, left: 18),
                              actionsPadding: EdgeInsets.all(10),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              insetPadding: EdgeInsets.all(0),
                              content: Text(
                                LanguageProvider.getMap()["general"]["sure"],
                                style: TextStyle(fontSize: 18),
                              ),
                              actions: [
                                TextButton.icon(
                                  onPressed: () async => {
                                    prov.stop(),
                                    Provider.of<WorkoutPageProvider>(context,
                                            listen: false)
                                        .selectPage(2, workout),
                                    Navigator.of(context).pop()
                                  },
                                  label: Text(
                                    "Stop",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  icon: Icon(
                                    Icons.stop,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => {Navigator.pop(context)},
                                  label: Text(
                                      LanguageProvider.getMap()["general"]
                                          ["cancel"]),
                                  icon: Icon(Icons.arrow_back),
                                )
                              ],
                            ),
                          )
                        },
                        label: Text("Stop"),
                        icon: Icon(Icons.stop),
                      ),
                    ),
                  ),
                ],
              ),
            }[prov.running],
          )
        ],
      ),
    );
  }
}
