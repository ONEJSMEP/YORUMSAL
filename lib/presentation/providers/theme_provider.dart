import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  /// Light ve Dark modlar için modern temalar
  ThemeData get lightTheme => modernLightTheme;
  ThemeData get darkTheme => modernDarkTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
