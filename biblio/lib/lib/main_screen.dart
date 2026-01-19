import 'package:flutter/material.dart';
import 'marketplace/screens/marketplace_home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/community_screen.dart'; 
import 'screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final Color colorBark = const Color(0xFF41302C);   // Selected Item
  final Color colorSilt = const Color(0xFF685C55);   // Unselected Item
  final Color colorCream = const Color(0xFFF7F3E8);  // Bar Background

  // THE SCREENS
  final List<Widget> _screens = [
    MarketplaceHomeScreen(),       // 0: Marketplace 
    const UpcomingEventsScreen(),   // 1: Community
    const ChatListScreen(),        // 2: Chat
    const ProfileScreen(),         // 3: Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body switches based on which button is clicked
      body: _screens[_currentIndex],

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: colorBark.withOpacity(0.1),
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorBark),
          ),
        ),
        child: NavigationBar(
          height: 70,
          backgroundColor: colorCream, // Light Cream background
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => setState(() => _currentIndex = index),
          destinations: [
            // 1. Marketplace (Basket/Shop)
            NavigationDestination(
              icon: Icon(Icons.shopping_basket_outlined, color: colorSilt),
              selectedIcon: Icon(Icons.shopping_basket, color: colorBark),
              label: 'Market',
            ),
            // 2. Community
            NavigationDestination(
              icon: Icon(Icons.groups_outlined, color: colorSilt),
              selectedIcon: Icon(Icons.groups, color: colorBark),
              label: 'Community',
            ),
            // 3. Chat
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline, color: colorSilt),
              selectedIcon: Icon(Icons.chat_bubble, color: colorBark),
              label: 'Chat',
            ),
            // 4. Profile
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: colorSilt),
              selectedIcon: Icon(Icons.person, color: colorBark),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
