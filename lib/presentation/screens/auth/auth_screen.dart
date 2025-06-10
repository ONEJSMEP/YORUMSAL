import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  final String userRole;

  const AuthScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade500, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo veya ikon
                Icon(Icons.home, size: 64, color: Colors.white),
                const SizedBox(height: 16),

                // Uygulama adı
                const Text(
                  'YORUMSAL',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 32),

                // Form kartı
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AuthForm(userRole: userRole),

                      const SizedBox(height: 16),

                      if (authProvider.status == AuthStatus.loading)
                        const CircularProgressIndicator(),

                      if (authProvider.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            authProvider.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
