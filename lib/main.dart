import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
// Sadece FirebaseAuth ve User import ediliyor, çakışma olmaz!
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'app.dart';
import 'presentation/providers/auth_provider.dart'; // Kendi AuthProvider'ını kullan!
import 'presentation/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase'i başlat
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(FirebaseAuth.instance),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
