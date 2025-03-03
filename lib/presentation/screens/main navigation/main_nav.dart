import 'dart:io';

import 'package:flutter/material.dart';
import 'screens/exploreScreen.dart';
import 'screens/bondScreen.dart';
import 'screens/profileScreen.dart';
import 'screens/settingsScreen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 2; // Default index set to Profile page

  // List of screens corresponding to each BottomNavigationBarItem
  final List<Widget> _screens = [
    ExploreScreen(),
    MyMatchScreen(),
    MyProfileScreen(),
    SettingsScreen(),
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
      