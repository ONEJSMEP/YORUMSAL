import 'presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        Widget homeWidget;
        if (authProvider.status == AuthStatus.authenticated) {
          homeWidget = const HomeScreen();
        } else {
          homeWidget = const SplashScreen();
        }

        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: homeWidget,
          routes: {
            '/home': (context) => const HomeScreen(),
            '/splash': (context) => const SplashScreen(),
            // Diğer route'lar burada tanımlanabilir
          },
              );
            },
          );
        }
      }