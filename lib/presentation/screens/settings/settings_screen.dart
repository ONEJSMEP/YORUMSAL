import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      
   
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSettingCard(
            context: context,
            icon: themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            title: 'Karanlık Mod',
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.language,
            title: 'Uygulama Dili',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dil seçimi yakında eklenecektir.')),
              );
            },
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.notifications_outlined,
            title: 'Bildirim Ayarları',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bildirim ayarları yakında eklenecektir.')),
              );
            },
          ),
          _buildSettingCard(
            context: context,
            icon: Icons.info_outline,
            title: 'Hakkında',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'YORUMSAL',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 Tüm Hakları Saklıdır',
              );
            },
          ),
          if (authProvider.currentUser != null)
            _buildSettingCard(
              context: context,
              icon: Icons.logout,
              title: 'Çıkış Yap',
              iconColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.error,
              onTap: () async {
                await authProvider.signOut();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? const Color(0xFF1E88E5)),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
