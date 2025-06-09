import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  static const routeName = '/role-selection';

  const RoleSelectionScreen({super.key});

  void _navigateToAuth(BuildContext context, String role) {
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
      appBar: AppBar(title: const Text('Rol Seç')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToAuth(context, 'owner'),
              child: const Text('Ev Sahibi Olarak Devam Et'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToAuth(context, 'reviewer'),
              child: const Text('Yorumcu Olarak Devam Et'),
            ),
          ],
        ),
      ),
    );
  }
}
