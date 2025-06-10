import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Yüksek kontrastlı canlı tema tanımı (Tema 4)
final ThemeData highContrastTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Colors.tealAccent.shade200,
    secondary: Colors.amberAccent.shade700,
    surface: Colors.grey.shade900,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.amberAccent.shade700,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.amberAccent.shade700,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.amberAccent.shade700),
    centerTitle: true,
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF2A2A2A),
    elevation: 6,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.tealAccent.shade200,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      shape: const StadiumBorder(),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade800,
    labelStyle: const TextStyle(color: Colors.white70),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.tealAccent.shade200, width: 2),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey.shade900,
    selectedItemColor: Colors.amberAccent.shade700,
    unselectedItemColor: Colors.white60,
    showUnselectedLabels: true,
    elevation: 8,
  ),
  textTheme: TextTheme(
    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyLarge: const TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: const TextStyle(fontSize: 14, color: Colors.white70),
  ),
);

class CoreThemeProvider extends ChangeNotifier {
  static final CoreThemeProvider instance = CoreThemeProvider._();
  CoreThemeProvider._() {
    _loadThemeFromPrefs();
  }

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeData get theme => highContrastTheme;
}
