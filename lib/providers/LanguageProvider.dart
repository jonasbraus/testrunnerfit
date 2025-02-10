import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  static String lang = "de";
  static Map<String, dynamic> langSet = {
    "de": {
      "home": {
        "welcome": "Wilkommen",
        "last7dayactivity": "Aktivität letze 7 Tage",
        "lastworkout": "Letzes Workout"
      },
      "exercises": {
        "exercise": "Übung",
        "addexercise": "Neue Übung",
        "help": "Halte eine Übung um sie zu bearbeiten",
        "all": "Alle",
        "arms": "Arme",
        "chest": "Brust",
        "stomach": "Bauch",
        "back": "Rücken",
        "legs": "Beine",
        "fullbody": "Ganzer Körper",
        "editexercise": "Übung bearbeiten",
        "exercisename": "Name der Übung",
        "weight": "Gewicht",
        "trainingregion": "Körperregion"
      },
      "workouts": {
        "exercisedisplay": "Übungen",
        "newworkout": "Neues Workout",
        "help": "Klicke ein Workout zum starten \n\nHalte ein Workout zum bearbeiten \n\nErstelle vor deinem ersten Workout Übungen",
        "addexercise": "Übung hinzufügen",
        "back": "Zurück",
        "summary": "Übersicht",
        "finish": "Beenden",
        "searchexercises": "Übung Suchen",
        "editworkout": "Workout Bearbeiten",
        "finishedcount": "Abgeschlossene Übungen",
        "exercises": "Übungen"
      },
      "settings": {
        "settings": "Einstellungen",
        "colorscheme": "Farbthema",
        "language": "Sprache",
        "gymgoal": "Gym Ziel"
      },
      "general": {
        "help": "Hilfe",
        "delete": "Löschen",
        "save": "Speichern",
        "sure": "Sicher",
        "cancel": "Zurück"
      },
      "titles": [
        "Home",
        "Übungen",
        "Workouts",
        "Einstellungen"
      ]
    },
    "en": {
      "home": {
        "welcome": "Welcome",
        "last7dayactivity": "Last 7 days activity",
        "lastworkout": "Last Workout"
      },
      "exercises": {
        "exercise": "Exercise",
        "addexercise": "Add Exercise",
        "help": "Hold an exercise to edit",
        "all": "All",
        "arms": "Arms",
        "chest": "Chest",
        "stomach": "Stomach",
        "back": "Back",
        "legs": "Legs",
        "fullbody": "Full Body",
        "editexercise": "Edit Exercise",
        "exercisename": "Exercise Name",
        "weight": "Weight",
        "trainingregion": "Training Region"
      },
      "workouts": {
        "exercisedisplay": "Exercises",
        "newworkout": "New Workout",
        "help": "Click a workout to start \n\nHold a workout to edit \n\nCreate exercises before your first workout",
        "addexercise": "Add Exercise",
        "back": "Back",
        "summary": "Summary",
        "finish": "Finish",
        "searchexercises": "Search Exercises",
        "editworkout": "Edit Workout",
        "finishedcount": "Finished Exercises",
        "exercises": "Exercises"
      },
      "settings": {
        "settings": "Settings",
        "colorscheme": "Color Scheme",
        "language": "Language",
        "gymgoal": "Gym Goal"
      },
      "general": {
        "help": "Help",
        "delete": "Delete",
        "save": "Save",
        "sure": "Sure",
        "cancel": "Cancel"
      },
      "titles": [
        "Home",
        "Exercises",
        "Workouts",
        "Settings"
      ]
    }
  };

  static Map<String, dynamic> getMap() {
    return langSet[lang];
  }

  void updateLang(String l) {
    lang = l;
    notifyListeners();
  }
}