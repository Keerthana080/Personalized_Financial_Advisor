import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/ai_suggestion_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import '../screens/goals_screen.dart';
import '../screens/insights_screen.dart';
import '../screens/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // 🎨 FinCoach palette
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color accent = Color(0xFFB79CFF);

  final _screens = const [
    HomeScreen(),
    InsightsScreen(), // Weekly / Monthly
    AiSuggestionScreen(), // AI assistant
    GoalsScreen(), // Goals
    ProfileScreen(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseDark,
      body: _screens[_currentIndex],

      // 🔻 BOTTOM NAV BAR (THEMED)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,

        backgroundColor: baseDark,
        selectedItemColor: accent,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_view_week),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: 'AI',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
