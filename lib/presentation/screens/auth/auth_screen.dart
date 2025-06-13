import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';


class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  final String userRole;

  const AuthScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF13161F),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // YORUMSAL YAZISI
            const Text(
              'YORUMSAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            // Sign In Buton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4067F6),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                child: const Text("Sign In"),
              ),
            ),
            const SizedBox(height: 16),
            // Create Account Buton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF23262C),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                child: const Text("Create Account"),
              ),
            ),
            const SizedBox(height: 22),
            const Text("Or Login with", style: TextStyle(color: Colors.white70, fontSize: 15)),
            const SizedBox(height: 16),
            // GOOGLE İLE GİRİŞ BUTONU - SİYAH KUTULU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                  color: Colors.black,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // Google ile giriş işlemi
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/google_icon.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Continue with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // ALTTA TERMS AND CONDITIONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text.rich(
                TextSpan(
                  text: "By creating an account or signing you agree to our ",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                  children: const [
                    TextSpan(
                      text: "Terms and Conditions",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
