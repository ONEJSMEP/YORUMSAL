import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToAuth(String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AuthScreen(userRole: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO: Kendi logonla değiştir (örnek: 'assets/logo.png')
              Image.asset(
                'assets/images/app_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 32),
              const Text(
                'Emlak Uygulaması',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => _navigateToAuth('owner'),
                child: const Text('Ev Sahibi Olarak Devam Et'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _navigateToAuth('reviewer'),
                child: const Text('Yorumcu Olarak Devam Et'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

