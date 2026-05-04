import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'my_bookings_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; 
  final List<Widget> _pages = [
    const ProfileScreen(),
    const MyBookingsScreen(),
    const HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFE79C24),
        unselectedItemColor: const Color(0xFF9CA3AF),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "حسابي"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: "حجوزاتي"),
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "الرئيسية"),
        ],
      ),
    );
  }
}