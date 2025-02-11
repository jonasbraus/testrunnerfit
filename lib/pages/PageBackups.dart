import 'package:fitflut/helpers/FirebaseHelper.dart';
import 'package:fitflut/providers/LoginProvider.dart';
import 'package:flutter/material.dart';

import '../helpers/DatabaseHelper.dart';
import '../providers/LanguageProvider.dart';

class PageBackups extends StatefulWidget {
  const PageBackups({super.key});

  @override
  State<PageBackups> createState() => _PageBackupsState();
}

class _PageBackupsState extends State<PageBackups> {
  Future<Map<String, Object?>> getBackups() async {
    try {
      Map<String, Object?> backups =
          await FirebaseHelper.getDocumentIDs(LoginProvider.user!.uid);
      return backups;
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

    return {};
  }

  Widget buildBackupOverview(AsyncSnapshot<Map<String, Object?>> snapshot) {
    if (!snapshot.hasData) {
      return Container();
    }

    List<Widget> children = [];

    for (String key in snapshot.data!.keys) {
      children.add(
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withAlpha(20),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              Text(
                "${key.split(".")[0].split(":")[0].replaceAll("-", ".")}:${key.split(".")[0].split(":")[1]}",
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.only(top: 18, left: 18),
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
                                await FirebaseHelper.deleteBackup(
                                    LoginProvider.user!.uid, key),
                                setState(() {}),
                                Navigator.of(context).pop(),
                              },
                              label: Text(
                                LanguageProvider.getMap()["general"]["delete"],
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              icon: Icon(
                                Icons.delete,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => {Navigator.pop(context)},
                              label: Text(LanguageProvider.getMap()["general"]
                                  ["cancel"]),
                              icon: Icon(Icons.arrow_back),
                            )
                          ],
                        ),
                      )
                    },
                    label: Text("Delete"),
                    icon: Icon(Icons.delete_rounded),
                  ),
                  FilledButton.icon(
                    onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.only(top: 18, left: 18),
                          actionsPadding: EdgeInsets.all(10),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          insetPadding: EdgeInsets.all(0),
                          content: Text(
                            LanguageProvider.getMap()["general"]["sure"] +
                                "\nLocal data will be deleted!",
                            style: TextStyle(fontSize: 18),
                          ),
                          actions: [
                            TextButton.icon(
                              onPressed: () async => {
                                await DatabaseHelper.setDBContents(snapshot
                                    .data![key] as Map<String, Object?>),
                                setState(() {}),
                                Navigator.of(context).pop(),
                              },
                              label: Text(
                                "Restore",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                              ),
                              icon: Icon(
                                Icons.backup_outlined,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => {Navigator.pop(context)},
                              label: Text(LanguageProvider.getMap()["general"]
                                  ["cancel"]),
                              icon: Icon(Icons.arrow_back),
                            )
                          ],
                        ),
                      )
                    },
                    label: Text("Restore"),
                    icon: Icon(Icons.backup_rounded),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.secondary.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        title: Text("Backups"),
      ),
      body: FutureBuilder<Map<String, Object?>>(
        future: getBackups(),
        builder: (context, snapshot) => buildBackupOverview(snapshot),
      ),
    );
  }
}
