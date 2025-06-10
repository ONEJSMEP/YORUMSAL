import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart'; // Uygulamanın ana widget'i burada
import 'services/supabase_service.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase'i başlat
  await supabaseService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(supabaseService.client),
        ),
        // Diğer provider'lar buraya eklenebilir
      ],
      child: const MyApp(),
    ),
  );
}
