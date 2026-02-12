import 'package:flutter/material.dart';
import '../drawer/screen_preview.dart';

class ScreenStackController extends ChangeNotifier {
  final List<ScreenPreview> _screens = [];
  final int maxScreens;

  ScreenStackController({this.maxScreens = 10});

  List<ScreenPreview> get screens => List.unmodifiable(_screens);

  void pushScreen(ScreenPreview screen) {
    _screens.removeWhere((s) => s.title == screen.title);
    _screens.insert(0, screen);

    if (_screens.length > maxScreens) {
      _screens.removeRange(maxScreens, _screens.length);
    }

    notifyListeners();
  }

  void removeScreen(String title) {
    _screens.removeWhere((s) => s.title == title);
    notifyListeners();
  }

  void clearAll() {
    _screens.clear();
    notifyListeners();
  }

  void navigateToScreen(String title) {
    final index = _screens.indexWhere((s) => s.title == title);
    if (index != -1) {
      _screens.removeRange(0, index);
      notifyListeners();
    }
  }
}
