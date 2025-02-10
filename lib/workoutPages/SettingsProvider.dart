import 'dart:ui';

import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  static int selectedColor = 0;
  List<Color> colors = [Colors.blue, Colors.green, Colors.purple, Colors.red, Colors.orange, Colors.pink];

  void selectColor(int id) {
    selectedColor = id;
    notifyListeners();
  }

  Color getColor() {
    return colors[selectedColor];
  }
}