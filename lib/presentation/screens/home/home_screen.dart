import 'package:flutter/material.dart';
import '../property/property_list_screen.dart';
import '../map/map_screen.dart'; // map_screen.dart oluşturulacak
import '../profile/profile_screen.dart'; // profile_screen.dart oluşturulacak
import '../settings/settings_screen.dart'; // settings_screen.dart oluşturulacak

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const PropertyListScreen(), // property_list_screen.dart oluşturulacak
    const MapScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  final List<String> _screenTitles = [
    'Kiralık Evler',
    'Harita',
    'Profilim',
    'Ayarlar',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitles[_selectedIndex]),
        // İsteğe bağlı: Arama veya filtreleme butonu eklenebilir
        // actions: _selectedIndex == 0 ? [
        //   IconButton(icon: Icon(Icons.search), onPressed: () { /* Arama ekranına git */ }),
        // ] : null,
      ),
      body: IndexedStack( // Ekranlar arasında geçiş yaparken state'i korur
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Evler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Harita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // 4+ item için fixed iyidir
      ),
    );
  }
}