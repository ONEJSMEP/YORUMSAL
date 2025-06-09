import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

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

  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.teal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A6572),
        primary: const Color(0xFF4A6572),
        secondary: const Color(0xFFFF9800),
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF4A6572),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A6572), width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade700),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
      ),
      useMaterial3: true,
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.teal,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4A6572),
        primary: const Color(0xFF4A6572),
        secondary: const Color(0xFFFF9800),
        surface: const Color(0xFF1E1E1E),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
        ),
        labelStyle: TextStyle(color: Colors.grey.shade400),
        hintStyle: TextStyle(color: Colors.grey.shade500),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: const Color(0xFFFF9800),
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      useMaterial3: true,
    );
  }
}
