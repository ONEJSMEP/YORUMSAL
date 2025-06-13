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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : const Color(0xFF1E88E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Ayarlar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
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
            _buildSettingCard(
              context: context,
              icon: Icons.logout,
              title: 'Çıkış Yap',
              iconColor: Theme.of(context).colorScheme.error,
              textColor: Theme.of(context).colorScheme.error,
              onTap: () async {
                await authProvider.signOut();
                Navigator.of(context).pushReplacementNamed('/splash');
              },
            ),
          ],
        ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(icon, color: iconColor ?? Theme.of(context).iconTheme.color),
        title: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor ?? Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        trailing: trailing ??
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade500),
              onTap: onTap,
            ),
          );
        }
      }