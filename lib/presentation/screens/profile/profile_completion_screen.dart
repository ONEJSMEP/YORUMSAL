import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_review_app/services/auth_service.dart';

class ProfileCompletionScreen extends StatefulWidget {
  @override
  State<ProfileCompletionScreen> createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilini Tamamla')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Ad'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: 'Soyad'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await _authService.saveUserProfile(
                    uid: user.uid,
                    email: user.email ?? '',
                    name: _nameController.text,
                    surname: _surnameController.text,
                  );
                  if (!mounted) return;
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              },
              child: const Text('Kaydet ve Devam Et'),
            ),
          ],
        ),
      ),
    );
  }
}