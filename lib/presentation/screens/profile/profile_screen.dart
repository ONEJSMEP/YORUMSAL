import 'package:flutter/material.dart';
import '../settings/settings_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFF1E88E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // PROFİL FOTO
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDarkMode
                      ? [Colors.grey.shade800, Colors.grey.shade900]
                      : [Colors.blue.shade400, Colors.indigo.shade600],
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: Icon(Icons.person, size: 48, color: Colors.grey.shade400),
              ),
            ),

            const SizedBox(height: 16),

            // KULLANICI ADI
            Text(
              'Kullanıcı Adı',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 6),

            // ROL / BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.orange.shade100.withOpacity(0.2) : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'VIP',
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // E-POSTA
            Text(
              'user@example.com',
              style: TextStyle(
                color: textColor,
              ),
            ),

            const SizedBox(height: 32),

            // PROFİL SEÇENEKLERİ
             _buildProfileOption(
              context,
              icon: Icons.edit,
              title: 'Profili Düzenle',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.comment_outlined,
              title: 'Yorumlarım',
              onTap: () {},
            ),
            _buildProfileOption(
              context,
              icon: Icons.history,
              title: 'Görüntüleme Geçmişi',
              onTap: () {},
            ),
            _buildProfileOption(
              context,
              icon: Icons.help_outline,
              title: 'Yardım',
              onTap: () {},
            ),
            // Çıkış ve ayarlar burada kaldırıldı, ayarlar sadece sağ üstte ikon olarak var
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
        onTap: onTap,
      ),
    );
  }
}