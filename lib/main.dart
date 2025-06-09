import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart'; // app.dart dosyasını oluşturacağız
import 'core/theme.dart';
import 'services/supabase_service.dart';
import 'presentation/providers/auth_provider.dart'; // auth_provider.dart dosyasını oluşturacağız

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase'i başlat
  await supabaseService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(supabaseService.client)),
        // Diğer provider'lar buraya eklenebilir
      ],
      child: const MyApp(),
    ),
  );
}