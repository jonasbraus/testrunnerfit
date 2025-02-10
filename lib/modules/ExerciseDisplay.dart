import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/gymPages/PageGymEditExercise.dart';
import 'package:fitflut/helpers/Exercise.dart';
import 'package:flutter/material.dart';

import '../providers/LanguageProvider.dart';

class ExerciseDisplay extends StatelessWidget {
  final Exercise exercise;

  const ExerciseDisplay({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PageGymEditExercise(exercise: exercise),
        ))
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              image: AssetImage("assets/body.jpeg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.surface.withAlpha(150),
                  BlendMode.srcATop)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                exercise.name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.heart_broken_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${exercise.weight} kg",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        {
                          "stomach": LanguageProvider.getMap()["exercises"]
                              ["stomach"],
                          "legs": LanguageProvider.getMap()["exercises"]
                              ["legs"],
                          "chest": LanguageProvider.getMap()["exercises"]
                              ["chest"],
                          "arms": LanguageProvider.getMap()["exercises"]
                              ["arms"],
                          "fullBody": LanguageProvider.getMap()["exercises"]
                              ["fullbody"],
                          "back": LanguageProvider.getMap()["exercises"]["back"]
                        }["${exercise.bodyRegion.toString().split('.')[1]}"]!,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
