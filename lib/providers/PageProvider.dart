import 'package:fitflut/pages/PageCalories.dart';
import 'package:fitflut/pages/PageGym.dart';
import 'package:fitflut/pages/PageHome.dart';
import 'package:fitflut/pages/PageSettings.dart';
import 'package:fitflut/pages/PageWorkout.dart';
import 'package:flutter/cupertino.dart';

import 'LanguageProvider.dart';

class PageProvider extends ChangeNotifier {
  int selectedPage = 0;
  List<Widget> pages = [PageHome(), PageGym(), PageWorkout(), PageSettings()];

  String getSelectedTitle() {
    return LanguageProvider.getMap()["titles"][selectedPage];
  }

  Widget getPage() {
    return pages[selectedPage];
  }

  void changePage(int index) {
    selectedPage = index;
    notifyListeners();
  }
}