import 'package:flutter/material.dart';


class BottomNavBar extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int value) {
    if (value == _currentIndex) return;
    _currentIndex = value;
    notifyListeners();
  }
}


