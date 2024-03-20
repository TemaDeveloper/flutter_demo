import 'package:flutter/material.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;
  Flavor currentFlavor;

  ThemeProvider(this.currentFlavor)
      : _themeData = catppuccinTheme(currentFlavor);

  ThemeData get themeData => _themeData;

  void setFlavor(Flavor flavor) {
    currentFlavor = flavor;
    _themeData = catppuccinTheme(flavor);
    notifyListeners();
  }

  static ThemeData catppuccinTheme(Flavor flavor) {
    Color primaryColor = flavor.mauve;
    Color secondaryColor = flavor.pink;
    return ThemeData(
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
            color: flavor.text, fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: flavor.crust,
        foregroundColor: flavor.mantle,
      ),
      colorScheme: ColorScheme(
        background: flavor.base,
        brightness: Brightness.light,
        error: flavor.surface2,
        onBackground: flavor.text,
        onError: flavor.red,
        onPrimary: primaryColor,
        onSecondary: secondaryColor,
        onSurface: flavor.text,
        primary: flavor.crust,
        secondary: flavor.mantle,
        surface: flavor.surface0,
      ),
      textTheme: TextTheme().apply(
        bodyColor: flavor.text,
        displayColor: primaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
      ),
    );
  }
}
