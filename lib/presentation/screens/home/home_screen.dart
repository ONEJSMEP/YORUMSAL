import 'package:flutter/material.dart';
import '../property/property_list_screen.dart';
import '../map/map_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CombinedMapAndListScreen(),
    const ProfileScreen(),
  ];

  final List<String> _screenTitles = [
    '',
    'Profil',
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
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.only(top: 4),
              child: Icon(Icons.map_rounded, size: 38), // Büyük harita ikonu
            ),
            label: '', // Yazı yok
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          // Sağ taraf boş bırakılıyor, eklenmiyor
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Harita üstte, evler listesi altta birleşik ekran
class CombinedMapAndListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: MapScreen(),
        ),
        Expanded(
          child: PropertyListScreen(),
        ),
      ],
    );
  }
}