import 'package:flutter/material.dart';
import 'screens/explore_screen.dart';
import 'screens/bond_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2; // Default index set to Profile page

  // List of screens corresponding to each BottomNavigationBarItem
  final List<Widget> _screens = [
    const ExploreScreen(),
    const BondScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("MyProfileScreen Loaded");
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xFFE7EFEE),
        backgroundColor: Color(0xFF5E77DF),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'My Bond'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: _screens[_selectedIndex],
      appBar: AppBar(title: Text('Main Nav')),
    );
  }
}
      