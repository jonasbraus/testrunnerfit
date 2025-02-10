import 'package:fitflut/helpers/Workout.dart';
import 'package:fitflut/providers/WorkoutUpdateProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';

import '../helpers/DatabaseHelper.dart';
import '../helpers/Exercise.dart';
import '../providers/LanguageProvider.dart';

class PageWorkoutAdd extends StatefulWidget {
  const PageWorkoutAdd({super.key});

  @override
  State<PageWorkoutAdd> createState() => _PageWorkoutAddState();
}

class _PageWorkoutAddState extends State<PageWorkoutAdd> {
  Future<List<Exercise>> getExercises(String filter) async {
    List<Exercise> output = await DatabaseHelper.getExercises(filter);
    output.sort((a, b) => a.bodyRegion.index.compareTo(b.bodyRegion.index));
    return output;
  }

  String name = "";
  List<Exercise> exercises = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        title: Text(LanguageProvider.getMap()["workouts"]["newworkout"]),
      ),
      body: FutureBuilder(
        future: getExercises(""),
        builder: (context, snapshot) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(
                    labelText: "Workout Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: FilledButton.icon(
                onPressed: () => {
                  showSearch(
                    context: context,
                    delegate: SearchPage<Exercise>(
                      items: snapshot.data!,
                      searchLabel: LanguageProvider.getMap()["workouts"]
                          ["searchexercises"],
                      filter: (exercise) => [exercise.name],
                      showItemsOnEmpty: true,
                      builder: (exercise) => GestureDetector(
                        onTap: () => setState(() {
                          exercises.add(exercise);
                          Navigator.pop(context);
                        }),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                  image: AssetImage("assets/body.jpeg"),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withAlpha(150),
                                      BlendMode.srcATop)),
                            ),
                            child: Center(
                              child: Text(
                                exercise.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(color: Colors.black, blurRadius: 5)
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                },
                label:
                    Text(LanguageProvider.getMap()["workouts"]["addexercise"]),
                icon: Icon(Icons.add),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.only(left: 10, top: 0, bottom: 5, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (Exercise exercise in exercises)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("assets/body.jpeg"),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withAlpha(150),
                                    BlendMode.srcATop),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () => {
                                    setState(() {
                                      exercises.remove(exercise);
                                    })
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 30,
                                  ),
                                ),
                                Text(
                                  exercise.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black, blurRadius: 5)
                                      ]),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  ],
                ),
              ),
            )),
            Container(
              padding:
                  EdgeInsets.only(left: 10, right: 10, bottom: 40, top: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withAlpha(25),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: FilledButton.icon(
                onPressed: () async => {
                  await DatabaseHelper.insertWorkout(
                    Workout(
                      id: -1,
                      name: name,
                      exercises: exercises,
                    ),
                  ),
                  Provider.of<WorkoutUpdateProvider>(context, listen: false)
                      .updateState(),
                  Navigator.of(context).pop()
                },
                icon: Icon(Icons.save_alt),
                label: Text(LanguageProvider.getMap()["general"]["save"]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
