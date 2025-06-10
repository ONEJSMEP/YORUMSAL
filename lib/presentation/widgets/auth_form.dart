import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home/home_screen.dart';

class AuthForm extends StatefulWidget {
  final String userRole;
  const AuthForm({Key? key, required this.userRole}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _fullName = '';

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState?.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success;
      if (_isLogin) {
        success = await authProvider.signIn(_email, _password);
      } else {
        success = await authProvider.signUp(
          _email,
          _password,
          fullName: _fullName,
          userRole: widget.userRole,
        );
      }

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (!success && authProvider.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (!_isLogin)
            TextFormField(
              key: const ValueKey('fullName'),
              autocorrect: false,
              textCapitalization: TextCapitalization.words,
              enableSuggestions: false,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 4) {
                  return 'Lütfen en az 4 karakter girin.';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                prefixIcon: Icon(Icons.person),
              ),
              onSaved: (value) {
                _fullName = value ?? '';
              },
            ),
          const SizedBox(height: 16),
          TextFormField(
            key: const ValueKey('email'),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Geçerli bir e-posta adresi girin.';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'E-posta Adresi',
              prefixIcon: Icon(Icons.email),
            ),
            onSaved: (value) {
              _email = value ?? '';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            key: const ValueKey('password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 7) {
                return 'Şifre en az 7 karakter olmalı.';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Şifre',
              prefixIcon: Icon(Icons.lock),
            ),
            onSaved: (value) {
              _password = value ?? '';
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _trySubmit,
            child: Text(
              _isLogin ? 'Giriş Yap' : 'Kayıt Ol',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
            child: Text(
              _isLogin ? 'Yeni hesap oluştur' : 'Zaten bir hesabım var',
              style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
