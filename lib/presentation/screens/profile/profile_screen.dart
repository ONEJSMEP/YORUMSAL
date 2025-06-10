import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profil fotoğrafı
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Kullanıcı adı
            const Text(
              'Kullanıcı Adı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // BADGE (Dinamik yapmak için Text yerine değişken kullanabilirsin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'VIP', // Burayı dinamik yapabilirsin (örn: Admin, Standart, Yeni Üye ...)
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'user@example.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            // Profil seçenekleri
            _buildProfileOption(
              icon: Icons.edit,
              title: 'Profili Düzenle',
              onTap: () {
                // Profil düzenleme ekranına git
              },
            ),
            _buildProfileOption(
              icon: Icons.comment_outlined,
              title: 'Yorumlarım', // ← Favori Evlerim yerine
              onTap: () {
                // Burada UserCommentsScreen'e yönlendirebilirsin
                // Navigator.push(context, MaterialPageRoute(builder: (_) => UserCommentsScreen()));
              },
            ),
            _buildProfileOption(
              icon: Icons.history,
              title: 'Görüntüleme Geçmişi',
              onTap: () {
                // Geçmiş ekranına git
              },
            ),
            _buildProfileOption(
              icon: Icons.help,
              title: 'Yardım',
              onTap: () {
                // Yardım ekranına git
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Çıkış Yap',
              onTap: () {
                // Çıkış yap
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
