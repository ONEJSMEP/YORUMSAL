import 'package:flutter/material.dart';
import '../../core/theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  /// Görünür tema: yüksek kontrastlı tema
  ThemeData get lightTheme => highContrastTheme;
  ThemeData get darkTheme => highContrastTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
