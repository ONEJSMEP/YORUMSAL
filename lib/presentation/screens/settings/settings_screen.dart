import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            leading: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Karanlık Mod'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Dil'),
            subtitle: const Text('Türkçe (TR)'), // Dil seçimi eklenebilir
            onTap: () {
              // Dil seçimi ekranı veya dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dil seçimi özelliği yakında eklenecektir.')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profil Ayarları'),
            onTap: () {
              // Profil düzenleme ekranına git
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil ayarları özelliği yakında eklenecektir.')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Bildirim Ayarları'),
            onTap: () {
              // Bildirim ayarları ekranına git
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bildirim ayarları özelliği yakında eklenecektir.')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Hakkında'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Kiralık Ev Yorumları',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2023 Tüm Hakları Saklıdır',
              );
            },
          ),
          const Divider(),
          if (authProvider.currentUser != null)
            ListTile(
              leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
              title: Text('Çıkış Yap', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              onTap: () async {
                await authProvider.signOut();
                // Giriş ekranına yönlendirme MyApp widget'ı tarafından yapılacak
              },
            ),
        ],
      ),
    );
  }
}