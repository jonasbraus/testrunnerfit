import 'package:flutter/material.dart';

class GymPageFilterProvider extends ChangeNotifier {
  String filter = "";

  void setFilter(String filter) {
    this.filter = filter;
    notifyListeners();
  }
}