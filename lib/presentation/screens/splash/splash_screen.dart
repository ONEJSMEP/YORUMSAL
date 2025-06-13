import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  Future<void> _quickLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const testEmail = 'y@gmail.com';
    const testPassword = '1234567';

    final success = await authProvider.signIn(testEmail, testPassword);
    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hızlı giriş başarısız: ${authProvider.errorMessage ?? 'Bilinmeyen hata'}')),
      );
    }
  }

  void _askUserRole() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Ev Sahibi Olarak Devam Et'),
            onTap: () {
              Navigator.pop(context);
              _navigateToAuth('owner');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Yorumcu Olarak Devam Et'),
            onTap: () {
              Navigator.pop(context);
              _navigateToAuth('reviewer');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/giris_ev.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 48),
                alignment: Alignment.topCenter,
                child: Column(
                  children: const [
                    Text(
                      'YORUMSAL',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color:  Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Yorumlarla Kirala, Güvenle Yaşa',
                      style: TextStyle(fontSize: 14, color:  Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: _askUserRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Sign In'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _askUserRole,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Create Account'),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.white,)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Or Login with', style: TextStyle(color: Colors.white,)),
                        ),
                        Expanded(child: Divider(color: Colors.white,)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: const Text('Continue with Google'),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: _quickLogin,
                      child: const Text(
                        'Hızlı Giriş (Geçici)',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
