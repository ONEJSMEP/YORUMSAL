import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/home/home_screen.dart'; // <-- YOLU DÜZELT

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
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else if (!success && authProvider.errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
              onSaved: (value) {
                _fullName = value ?? '';
              },
            ),
          TextFormField(
            key: const ValueKey('email'),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            enableSuggestions: false,
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Lütfen geçerli bir e-posta adresi girin.';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'E-posta Adresi'),
            onSaved: (value) {
              _email = value ?? '';
            },
          ),
          TextFormField(
            key: const ValueKey('password'),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 7) {
                return 'Şifre en az 7 karakter olmalıdır.';
              }
              return null;
            },
            decoration: const InputDecoration(labelText: 'Şifre'),
            obscureText: true,
            onSaved: (value) {
              _password = value ?? '';
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _trySubmit,
            child: Text(_isLogin ? 'Giriş Yap' : 'Kayıt Ol'),
          ),
          TextButton(
            child: Text(
              _isLogin ? 'Yeni hesap oluştur' : 'Zaten bir hesabım var',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              setState(() {
                _isLogin = !_isLogin;
              });
            },
          ),
        ],
      ),
    );
  }
}
