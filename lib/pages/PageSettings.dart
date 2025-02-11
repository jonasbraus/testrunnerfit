import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitflut/helpers/DatabaseHelper.dart';
import 'package:fitflut/helpers/FirebaseHelper.dart';
import 'package:fitflut/pages/PageAccount.dart';
import 'package:fitflut/pages/PageBackups.dart';
import 'package:fitflut/providers/GymgoalProvider.dart';
import 'package:fitflut/providers/LoginProvider.dart';
import 'package:fitflut/workoutPages/SettingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/LanguageProvider.dart';
import '../providers/PageProvider.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  void storeColorScheme(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("color", id);
  }

  void storeLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("lang", lang);
  }

  void storeGymgoal(int days) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("gymgoal", days);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
        child: Consumer<LanguageProvider>(
          builder: (context, provLang, child) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  LanguageProvider.getMap()["settings"]["language"] +
                      " | Account",
                  style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () =>
                        {provLang.updateLang("en"), storeLanguage("en")},
                    child: Text("en"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          LanguageProvider.lang == "en"
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(100)
                              : Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FilledButton(
                    onPressed: () => {
                      provLang.updateLang("de"),
                      storeLanguage("de"),
                    },
                    child: Text("de"),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          LanguageProvider.lang == "de"
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(100)
                              : Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Consumer<LoginProvider>(
                builder: (context, loginProv, child) => FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PageAccount(),
                    ));
                  },
                  label: LoginProvider.user == null
                      ? Text("Login")
                      : Text(LoginProvider.user!.email!),
                  icon: Icon(Icons.person),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(LanguageProvider.getMap()["settings"]["gymgoal"],
                  style: TextStyle(fontSize: 17)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<GymgoalProvider>(
                    builder: (context, goalProv, child) => Row(
                      children: [
                        Slider(
                          value: GymgoalProvider.goal.toDouble(),
                          onChanged: (value) => {
                            goalProv.setGoal(
                              value.toInt(),
                            ),
                            storeGymgoal(value.toInt())
                          },
                          divisions: 7,
                          min: 0,
                          max: 7,
                        ),
                        SizedBox(width: 10),
                        Text(
                          GymgoalProvider.goal.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              Consumer<LoginProvider>(
                builder: (context, loginProv, child) => {
                  true: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Backup",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: () async {
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
                                  onPressed: () async {
                                    Map<String, Object?> dbContent =
                                        await DatabaseHelper.getDBContents();
                                    String now =
                                        await FirebaseHelper.storeBackup(
                                            LoginProvider.user!.uid, dbContent);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Backup $now Created!")));
                                    Navigator.of(context).pop();
                                  },
                                  label: Text(
                                    "Create Backup",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  ),
                                  icon: Icon(
                                    Icons.backup_outlined,
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
                          );
                        },
                        label: Text("Create Backup"),
                        icon: Icon(Icons.backup),
                      ),
                      SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () {
                          try {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PageBackups()));
                          } catch (e) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SingleChildScrollView(
                                child: Text(
                                  e.toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ));
                          }
                        },
                        label: Text("Show Backups"),
                        icon: Icon(Icons.settings_backup_restore_rounded),
                      )
                    ],
                  ),
                  false: Container()
                }[LoginProvider.user != null]!,
              )
            ],
          ),
        ));
  }
}
