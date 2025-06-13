import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_review_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final PageController _pageController = PageController();
  String? _selectedRole;

  // Form alanları
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyPhoneController = TextEditingController();
  final TextEditingController _verifyEmailController = TextEditingController();
  final TextEditingController _signInEmailController = TextEditingController();
  final TextEditingController _signInPasswordController = TextEditingController();
  final TextEditingController _onlyPasswordController = TextEditingController();

  List<XFile> _selectedImages = [];
  final List<String> _countryCodes = ['+90', '+1', '+44', '+49', '+33'];
  String _selectedCountryCode = '+90';

  // Doğrulama ve giriş
  bool _isPhoneVerified = false;
  bool _isEmailVerified = false;
  bool _isRememberMe = false;
  bool _isLoggedIn = false;
  String? _rememberedEmail;
  String? _rememberedPhoto;
  bool _showOnlyPasswordScreen = false;

  // EKLENDİ: AuthService örneği
  final AuthService _authService = AuthService();

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
    _pageController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _tcController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _verifyPhoneController.dispose();
    _verifyEmailController.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _onlyPasswordController.dispose();
    super.dispose();
  }

  void _goToRolePage() {
    setState(() {
      _selectedRole = 'owner'; // Otomatik olarak ev sahibi seçili gelsin
      _showOnlyPasswordScreen = false;
    });
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToSignInPage() {
    setState(() {
      _showOnlyPasswordScreen = false;
    });
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToSplashPage() {
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      _nameController.clear();
      _phoneController.clear();
      _tcController.clear();
      _emailController.clear();
      _addressController.clear();
      _passwordController.clear();
      _verifyPhoneController.clear();
      _verifyEmailController.clear();
      _selectedImages = [];
      _selectedCountryCode = '+90';
      _isPhoneVerified = false;
      _isEmailVerified = false;
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages = images.take(10).toList();
      });
    }
  }

  // Simüle doğrulama kodu
  final String _sentPhoneCode = "1234";
  final String _sentEmailCode = "5678";

  Widget _buildCommonQuestions({bool showPhoto = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Ad Soyad',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZğüşöçıİĞÜŞÖÇ\s]')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<String>(
                value: _selectedCountryCode,
                underline: const SizedBox(),
                items: _countryCodes
                    .map((code) => DropdownMenuItem(
                          value: code,
                          child: Text(code),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCountryCode = val!;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.grey[100],
                  suffixIcon: _isPhoneVerified
                      ? const Icon(Icons.check, color: Colors.green)
                      : TextButton(
                          child: const Text("Doğrula"),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Telefon kodu gönderildi: $_sentPhoneCode")),
                            );
                          },
                        ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        if (!_isPhoneVerified)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _verifyPhoneController,
                    decoration: const InputDecoration(
                      labelText: "Telefon Kodu",
                    ),
                  ),
                ),
                TextButton(
                  child: const Text("Onayla"),
                  onPressed: () {
                    if (_verifyPhoneController.text == _sentPhoneCode) {
                      setState(() {
                        _isPhoneVerified = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Telefon doğrulandı!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Kod yanlış!")),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _tcController,
          decoration: InputDecoration(
            labelText: 'T.C. Kimlik No',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'E-posta',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
            suffixIcon: _isEmailVerified
                ? const Icon(Icons.check, color: Colors.green)
                : TextButton(
                    child: const Text("Doğrula"),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("E-posta kodu gönderildi: $_sentEmailCode")),
                      );
                    },
                  ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        if (!_isEmailVerified)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _verifyEmailController,
                    decoration: const InputDecoration(
                      labelText: "E-posta Kodu",
                    ),
                  ),
                ),
                TextButton(
                  child: const Text("Onayla"),
                  onPressed: () {
                    if (_verifyEmailController.text == _sentEmailCode) {
                      setState(() {
                        _isEmailVerified = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("E-posta doğrulandı!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Kod yanlış!")),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        const SizedBox(height: 16),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Adres',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Şifre',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
          ),
          obscureText: true,
        ),
        if (showPhoto) ...[
          const SizedBox(height: 20),
          Text(
            'En az 3 fotoğraf yüklemeniz lazım',
            style: TextStyle(
              color: _selectedImages.length < 3 ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ..._selectedImages.map((img) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(img.path),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )),
              if (_selectedImages.length < 10)
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Icon(Icons.add_a_photo, size: 28),
                  ),
                ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_isPhoneVerified && _isEmailVerified)
                ? () {
                    setState(() {
                      _isLoggedIn = true;
                      _rememberedEmail = _emailController.text;
                      _rememberedPhoto = _selectedImages.isNotEmpty ? _selectedImages.first.path : null;
                    });
                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
            ),
            child: const Text('Devam Et', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleQuestions() {
    if (_selectedRole == 'owner') {
      return _buildCommonQuestions(showPhoto: true);
    } else if (_selectedRole == 'reviewer') {
      return _buildCommonQuestions(showPhoto: false);
    }
    return const SizedBox.shrink();
  }

  Widget _buildSignInScreen() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.blueAccent;
    final textStyle = GoogleFonts.pacifico(
      fontSize: 15,
      color: isDark ? Colors.white70 : Colors.black87,
    );
    final buttonTextStyle = GoogleFonts.alfaSlabOne(
      fontSize: 16,
      color: Colors.black, // Giriş Yap yazısı siyah
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Geri butonu
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goToSplashPage,
            ),
          ),
          const SizedBox(height: 8),
          if (_showOnlyPasswordScreen && _rememberedEmail != null)
            Column(
              children: [
                if (_rememberedPhoto != null)
                  CircleAvatar(
                    backgroundImage: FileImage(File(_rememberedPhoto!)),
                    radius: 40,
                  )
                else
                  const CircleAvatar(
                    child: Icon(Icons.person, size: 40),
                    radius: 40,
                  ),
                const SizedBox(height: 12),
                Text(
                  _rememberedEmail!,
                  style: GoogleFonts.alfaSlabOne(fontWeight: FontWeight.bold, fontSize: 18, color: primaryColor),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _onlyPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text('Giriş Yap', style: buttonTextStyle),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showOnlyPasswordScreen = false;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'Farklı bir hesapla giriş yap',
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                TextField(
                  controller: _signInEmailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _signInPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.white,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                // Beni Hatırla barı
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Beni Hatırla',
                          style: textStyle.copyWith(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isRememberMe,
                        onChanged: (val) {
                          setState(() {
                            _isRememberMe = val;
                          });
                        },
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // --- E-POSTA/ŞİFRE İLE GİRİŞTE PROFİL KONTROLÜ EKLENDİ ---
                ElevatedButton(
                  onPressed: () async {
                    final user = await _authService.signInWithEmail(
                      _signInEmailController.text,
                      _signInPasswordController.text,
                    );
                    if (user != null) {
                      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                      if (!doc.exists || doc['name'] == null || doc['surname'] == null) {
                        if (!mounted) return;
                        Navigator.of(context).pushReplacementNamed('/profileCompletion');
                      } else {
                        if (!mounted) return;
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    } else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Giriş başarısız!')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black, // Yazı rengi siyah
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text('Giriş Yap', style: buttonTextStyle),
                ),
                // --- SONU ---
                const SizedBox(height: 12),
                // Farklı bir hesapla giriş yap barı
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showOnlyPasswordScreen = false;
                      _signInEmailController.clear();
                      _signInPasswordController.clear();
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      'Farklı bir hesapla giriş yap',
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/giris_ev.jpg',
              fit: BoxFit.cover,
              color: isDark ? Colors.black.withOpacity(0.5) : null,
              colorBlendMode: isDark ? BlendMode.darken : null,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Icon(Icons.home_rounded, size: 56, color: primaryColor),
                const SizedBox(height: 12),
                Text(
                  'YORUMSAL',
                  style: GoogleFonts.alfaSlabOne(
                    fontSize: 30,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Yorumlarla Kirala, Güvenle Yaşa',
                  style: GoogleFonts.pacifico(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 500,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // 1. Sayfa: Giriş butonları
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: _goToSignInPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 2,
                              ),
                              child: const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _goToRolePage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
                                foregroundColor: isDark ? Colors.white : Colors.black87,
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                elevation: 0,
                              ),
                              child: const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    'Or Login with',
                                    style: TextStyle(
                                      color: isDark ? Colors.white54 : Colors.black54,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // --- Google ile giriş butonu DEĞİŞTİRİLDİ ---
                            ElevatedButton.icon(
                              onPressed: () async {
                                final user = await _authService.signInWithGoogle();
                                if (user != null) {
                                  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                                  if (!doc.exists || doc['name'] == null || doc['surname'] == null) {
                                    if (!mounted) return;
                                    Navigator.of(context).pushReplacementNamed('/profileCompletion');
                                  } else {
                                    if (!mounted) return;
                                    Navigator.of(context).pushReplacementNamed('/home');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 1,
                              ),
                              icon: const Icon(Icons.g_mobiledata, size: 28),
                              label: const Text('Continue with Google'),
                            ),
                            // --- Google ile giriş butonu SONU ---
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed('/home');
                              },
                              icon: const Icon(Icons.flash_on),
                              label: const Text('Hızlı Giriş'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 2. Sayfa: Create Account (Rol seçimi ve sorular)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Geri butonu
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _goToSplashPage,
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _selectRole('owner'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedRole == 'owner'
                                          ? primaryColor
                                          : (isDark ? Colors.white12 : Colors.grey[200]),
                                      foregroundColor: _selectedRole == 'owner'
                                          ? Colors.white
                                          : (isDark ? Colors.white : Colors.black87),
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: _selectedRole == 'owner' ? 2 : 0,
                                    ),
                                    child: const Text('Ev Sahibi'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _selectRole('reviewer'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedRole == 'reviewer'
                                          ? primaryColor
                                          : (isDark ? Colors.white12 : Colors.grey[200]),
                                      foregroundColor: _selectedRole == 'reviewer'
                                          ? Colors.white
                                          : (isDark ? Colors.white : Colors.black87),
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: _selectedRole == 'reviewer' ? 2 : 0,
                                    ),
                                    child: const Text('Yorumcu'),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: _buildRoleQuestions(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 3. Sayfa: Sign In
                      _buildSignInScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}