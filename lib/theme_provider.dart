import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData currentTheme;

  ThemeProvider({required bool isDarkMode}) 
      : currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    if (currentTheme == ThemeData.light()) {
      currentTheme = ThemeData.dark();
    } else {
      currentTheme = ThemeData.light();
    }
    notifyListeners();
  }
}
