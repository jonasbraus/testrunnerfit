import 'package:fitflut/gymPages/PageGymAddExercise.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:fitflut/modules/ExerciseDisplay.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:fitflut/providers/GymPageFilterProvider.dart';
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';

import '../providers/LanguageProvider.dart';

class PageGym extends StatelessWidget {
  const PageGym({super.key});

  Future<List<Exercise>> getExercises(String filter) async {
    List<Exercise> output = await DatabaseHelper.getExercises(filter);
    return output;
  }

  List<Widget> buildExerciseChildren(AsyncSnapshot<List<Exercise>> snapshot) {
    if (snapshot.data == null) {
      return [Container()];
    }

    return [
      SizedBox(
        height: 10,
      ),
      for (Exercise exercise in snapshot.data!)
        ExerciseDisplay(exercise: exercise),
      SizedBox(
        height: 10,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseUpdateProvider>(
      builder: (context, exerciseUpdateProvider, child) => Consumer<GymPageFilterProvider>(
        builder: (context, gymPageProvider, child) => FutureBuilder(
          future: getExercises(gymPageProvider.filter),
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
                      child: Column(
                          spacing: 10,
                          children: buildExerciseChildren(snapshot)),
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
                          builder: (context) => PageGymAddExercise(),
                        ))
                      },
                      label: Text(LanguageProvider.getMap()["exercises"]["addexercise"]),
                      icon: Icon(Icons.add_rounded),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
