import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();

  DateTime? _birthDate;
  String? _gender;
  bool _emailVerified = false;
  bool _phoneVerified = false;
  bool _notificationsEnabled = true;
  XFile? _profileImage;
  final List<String> _genders = ['Kadın', 'Erkek', 'Diğer'];

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nicknameController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = picked;
      });
    }
  }

  void _showChangePasswordSheet() {
    final _oldPassController = TextEditingController();
    final _newPassController = TextEditingController();
    final _repeatPassController = TextEditingController();
    final _passFormKey = GlobalKey<FormState>();
    bool _obscureOld = true;
    bool _obscureNew = true;
    bool _obscureRepeat = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Form(
              key: _passFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Şifreyi Değiştir",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Eski Şifre
                  TextFormField(
                    controller: _oldPassController,
                    obscureText: _obscureOld,
                    decoration: InputDecoration(
                      labelText: "Eski Şifre",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureOld ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setModalState(() => _obscureOld = !_obscureOld),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty ? "Eski şifreyi giriniz" : null,
                  ),
                  const SizedBox(height: 16),
                  // Yeni Şifre
                  TextFormField(
                    controller: _newPassController,
                    obscureText: _obscureNew,
                    decoration: InputDecoration(
                      labelText: "Yeni Şifre",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setModalState(() => _obscureNew = !_obscureNew),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Yeni şifreyi giriniz";
                      if (v.length < 6) return "Şifre en az 6 karakter olmalı";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Yeni Şifre Tekrar
                  TextFormField(
                    controller: _repeatPassController,
                    obscureText: _obscureRepeat,
                    decoration: InputDecoration(
                      labelText: "Yeni Şifre (Tekrar)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureRepeat ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setModalState(() => _obscureRepeat = !_obscureRepeat),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Yeni şifreyi tekrar giriniz";
                      if (v != _newPassController.text) return "Şifreler eşleşmiyor";
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Vazgeç"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_passFormKey.currentState!.validate()) {
                              // Şifre değiştirme işlemi burada yapılabilir
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Şifre başarıyla değiştirildi!")),
                              );
                            }
                          },
                          child: const Text("Kaydet"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profil Fotoğrafı
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      backgroundImage: _profileImage != null ? Image.file(
                        File(_profileImage!.path),
                        fit: BoxFit.cover,
                      ).image : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 48, color: Colors.grey.shade500)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickProfileImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // İsim
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'İsim',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty ? 'İsim giriniz' : null,
              ),
              const SizedBox(height: 16),
              // Soyisim
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(
                  labelText: 'Soyisim',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Soyisim giriniz' : null,
              ),
              const SizedBox(height: 16),
              // Kullanıcı Adı
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty ? 'Kullanıcı adı giriniz' : null,
              ),
              const SizedBox(height: 16),
              // E-posta
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                  suffixIcon: _emailVerified
                      ? const Icon(Icons.verified, color: Colors.green)
                      : TextButton(
                          child: const Text('Doğrula'),
                          onPressed: () {
                            setState(() {
                              _emailVerified = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('E-posta doğrulandı (örnek)!')),
                            );
                          },
                        ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? 'E-posta giriniz' : null,
              ),
              const SizedBox(height: 16),
              // Telefon
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefon Numarası',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                  suffixIcon: _phoneVerified
                      ? const Icon(Icons.verified, color: Colors.green)
                      : TextButton(
                          child: const Text('Doğrula'),
                          onPressed: () {
                            setState(() {
                              _phoneVerified = true;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Telefon doğrulandı (örnek)!')),
                            );
                          },
                        ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Telefon numarası giriniz' : null,
              ),
              const SizedBox(height: 16),
              // Şifre Değiştir
              ElevatedButton.icon(
                onPressed: _showChangePasswordSheet,
                icon: const Icon(Icons.lock_outline),
                label: const Text('Şifreyi Değiştir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              const SizedBox(height: 16),
              // Adres
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              // Doğum Tarihi
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _birthDate ?? DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _birthDate = picked;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Doğum Tarihi',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                      filled: true,
                      fillColor: isDark ? Colors.white10 : Colors.white,
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _birthDate == null
                          ? ''
                          : '${_birthDate!.day}.${_birthDate!.month}.${_birthDate!.year}',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Cinsiyet
              DropdownButtonFormField<String>(
                value: _gender,
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
                decoration: InputDecoration(
                  labelText: 'Cinsiyet',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Hakkımda/Biyografi
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Hakkımda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Sosyal Medya
              TextFormField(
                controller: _instagramController,
                decoration: InputDecoration(
                  labelText: 'Instagram',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                  prefixIcon: const Icon(Icons.camera_alt_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _twitterController,
                decoration: InputDecoration(
                  labelText: 'Twitter',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                  prefixIcon: const Icon(Icons.alternate_email),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _linkedinController,
                decoration: InputDecoration(
                  labelText: 'LinkedIn',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: isDark ? Colors.white10 : Colors.white,
                  prefixIcon: const Icon(Icons.business_center_outlined),
                ),
              ),
              const SizedBox(height: 16),
              // Bildirim Tercihi
              SwitchListTile(
                value: _notificationsEnabled,
                onChanged: (val) => setState(() => _notificationsEnabled = val),
                title: const Text('Bildirimleri Aç'),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
    
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Burada güncelleme işlemini yapabilirsin
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profil güncellendi!')),
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Kaydet', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}