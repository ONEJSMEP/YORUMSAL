// lib/presentation/screens/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

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

  // Ortak form alanları
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<XFile> _selectedImages = [];

  // Ülke kodları
  final List<String> _countryCodes = ['+90', '+1', '+44', '+49', '+33'];
  String _selectedCountryCode = '+90';

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
    super.dispose();
  }

  void _goToRolePage() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _selectRole(String role) {
    setState(() {
      _selectedRole = role;
      // Formları temizle
      _nameController.clear();
      _phoneController.clear();
      _tcController.clear();
      _emailController.clear();
      _addressController.clear();
      _selectedImages = [];
      _selectedCountryCode = '+90';
    });
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages = images.take(10).toList(); // Maksimum 10 fotoğraf
      });
    }
  }

  Widget _buildCommonQuestions({bool showPhoto = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Ad Soyad (sadece harf)
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
        // Telefon (ülke kodu + sadece rakam)
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
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // T.C. Kimlik No (sadece rakam)
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
        // E-posta
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'E-posta',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
            fillColor: isDark ? Colors.white10 : Colors.grey[100],
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        // Adres
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
            onPressed: showPhoto
                ? (_selectedImages.length >= 3
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form başarıyla gönderildi!')),
                        );
                      }
                    : null)
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form başarıyla gönderildi!')),
                    );
                  },
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
                // Logo veya ikon
                Icon(Icons.home_rounded, size: 56, color: primaryColor),
                const SizedBox(height: 12),
                // Başlık
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
                              onPressed: _goToRolePage,
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
                            ElevatedButton.icon(
                              onPressed: () {},
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
                          ],
                        ),
                      ),
                      // 2. Sayfa: Rol seçimi ve sorular
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Geri butonu sol üstte
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  tooltip: 'Geri',
                                  onPressed: () {
                                    _pageController.animateToPage(
                                      0,
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ----------- DÜZENLENEN KISIM -----------
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _selectRole('owner'),
                                    icon: const Icon(Icons.home),
                                    label: const Text('Ev Sahibi'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedRole == 'owner'
                                          ? primaryColor
                                          : (isDark ? Colors.white12 : Colors.grey[200]),
                                      foregroundColor: _selectedRole == 'owner'
                                          ? Colors.white
                                          : (isDark ? Colors.white : Colors.black),
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _selectRole('reviewer'),
                                    icon: const Icon(Icons.person),
                                    label: const Text('Yorumcu'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _selectedRole == 'reviewer'
                                          ? primaryColor
                                          : (isDark ? Colors.white12 : Colors.grey[200]),
                                      foregroundColor: _selectedRole == 'reviewer'
                                          ? Colors.white
                                          : (isDark ? Colors.white : Colors.black),
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 1,
                                    ),
                                  ),
                                ),
                                // ----------- DÜZENLENEN KISIM SONU -----------
                              ],
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: _selectedRole == null
                                      ? const SizedBox.shrink()
                                      : _buildRoleQuestions(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
