import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitflut/firebase_options.dart';
import 'package:fitflut/gymPages/BodyRegions.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/providers/ExerciseUpdateProvider.dart';
import 'package:fitflut/providers/GymPageFilterProvider.dart';
import 'package:fitflut/providers/GymgoalProvider.dart';
import 'package:fitflut/providers/LanguageProvider.dart';
import 'package:fitflut/providers/LoginProvider.dart';
import 'package:fitflut/providers/PageProvider.dart';
import 'package:fitflut/providers/RunningWorkoutProvider.dart';
import 'package:fitflut/providers/WorkoutPageProvider.dart';
import 'package:fitflut/providers/WorkoutUpdateProvider.dart';
import 'package:fitflut/workoutPages/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:info_widget/info_widget.dart';
import 'package:json_theme/json_theme.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  LoginProvider.user = FirebaseAuth.instance.currentUser;

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    LoginProvider.user = user;
  });

  await DatabaseHelper.initDb();
  SettingsProvider.selectedColor = await getColor();
  LanguageProvider.lang = await getLang();
  GymgoalProvider.goal = await getGymgoal();


  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme,));
}

Future<int> getColor() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getInt("color") ?? 0;
}

Future<String> getLang() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString("lang") ?? "en";
}

Future<int> getGymgoal() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getInt("gymgoal") ?? 2;
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  const MyApp({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExerciseUpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GymPageFilterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutUpdateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutPageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RunningWorkoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GymgoalProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        )
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, prov, child) => Consumer<LanguageProvider>(
          builder: (context, value, child) => MaterialApp(
            theme: theme,
            debugShowCheckedModeBanner: false,
            home: const MyHome(),
          ),
        ),
      ),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<PageProvider>(
        builder: (context, pageProv, child) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withAlpha(25),
              borderRadius:
                  pageProv.selectedPage == 1 || pageProv.selectedPage == 2
                      ? BorderRadius.circular(0)
                      : BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
          padding: Platform.isIOS ? EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30) : EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 25),
          child: GNav(
            tabs: [
              GButton(
                icon: Icons.home_rounded,
              ),
              GButton(
                icon: Icons.heart_broken_rounded,
              ),
              GButton(
                icon: Icons.fitness_center_outlined,
              ),
              GButton(
                icon: Icons.settings,
              )
            ],
            iconSize: 22,
            style: GnavStyle.google,
            backgroundColor: Colors.transparent,
            activeColor: Theme.of(context).colorScheme.onPrimary,
            tabBackgroundColor: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.all(15),
            duration: Duration(seconds: 0),
            onTabChange: (value) =>
                Provider.of<PageProvider>(context, listen: false)
                    .changePage(value),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        // forceMaterialTransparency: true,
        actions: [
          Consumer<PageProvider>(
            builder: (context, value, child) => {
              0: Container(),
              1: Padding(
                padding: EdgeInsets.only(left: 0, right: 15, bottom: 0, top: 0),
                child: Consumer<GymPageFilterProvider>(
                  builder: (context, value, child) => DropdownButton<String>(
                    value: value.filter,
                    hint: Text("Filter"),
                    icon: Icon(Icons.sort),
                    items: [
                      DropdownMenuItem<String>(
                        value: "",
                        child:
                            Text(LanguageProvider.getMap()["exercises"]["all"]),
                      ),
                      DropdownMenuItem<String>(
                        value: "arms",
                        child: Text(
                            LanguageProvider.getMap()["exercises"]["arms"]),
                      ),
                      DropdownMenuItem<String>(
                        value: "chest",
                        child: Text(
                            LanguageProvider.getMap()["exercises"]["chest"]),
                      ),
                      DropdownMenuItem<String>(
                        value: "stomach",
                        child: Text(
                            LanguageProvider.getMap()["exercises"]["stomach"]),
                      ),
                      DropdownMenuItem<String>(
                        value: "back",
                        child: Text(
                            LanguageProvider.getMap()["exercises"]["back"]),
                      ),
                      DropdownMenuItem<String>(
                        value: "legs",
                        child: Text(
                            LanguageProvider.getMap()["exercises"]["legs"]),
                      ),
                      DropdownMenuItem<String>(
                        value: "fullBody",
                        child: Text(
                            LanguageProvider.getMap()["exercises"]["fullbody"]),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      value.setFilter(newValue!);
                    },
                  ),
                ),
              ),
              2: Container(),
              3: Container(),
              4: Container(),
            }[value.selectedPage]!,
          ),
          Consumer<PageProvider>(
            builder: (context, value, child) => {
              0: Container(),
              1: Padding(
                padding: EdgeInsets.only(right: 10),
                child: InfoWidget(
                  infoText: LanguageProvider.getMap()["exercises"]["help"],
                  iconData: Icons.info,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              2: Padding(
                padding: EdgeInsets.only(right: 10),
                child: InfoWidget(
                  infoText: LanguageProvider.getMap()["workouts"]["help"],
                  iconData: Icons.info,
                  iconColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              3: Container(),
              4: Container(),
            }[value.selectedPage]!,
          )
        ],
        title: Consumer<PageProvider>(
          builder: (context, value, child) => Text(
            value.getSelectedTitle(),
          ),
        ),
      ),
      body: Consumer<PageProvider>(
        builder: (context, value, child) => value.getPage(),
      ),
    );
  }
}
