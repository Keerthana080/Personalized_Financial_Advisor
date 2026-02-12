// import 'package:flutter/material.dart';

// import 'package:flutter_application_1/screens/ai_suggestion_screen.dart';
// import 'package:flutter_application_1/screens/home_screen.dart';
// import '../screens/goals_screen.dart';
// import '../screens/insights_screen.dart';
// import 'profile_screen.dart';

// class MainShell extends StatefulWidget {
//   const MainShell({super.key});

//   @override
//   State<MainShell> createState() => _MainShellState();
// }

// class _MainShellState extends State<MainShell> {
//   int _currentIndex = 0;

//   // 🎨 FinCoach palette
//   static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
//   static const Color accent = Color(0xFFB79CFF);

//   final _screens = const [
//     HomeScreen(),
//     InsightsScreen(), // Weekly / Monthly
//     AiSuggestionScreen(), // AI assistant
//     GoalsScreen(), // Goals
//     ProfileScreen(), // Profile
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: baseDark,
//       body: _screens[_currentIndex],

//       // 🔻 BOTTOM NAV BAR (THEMED)
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (i) => setState(() => _currentIndex = i),
//         type: BottomNavigationBarType.fixed,

//         backgroundColor: baseDark,
//         selectedItemColor: accent,
//         unselectedItemColor: Colors.white70,
//         showUnselectedLabels: true,
//         selectedLabelStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//         ),

//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_view_week),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_month),
//             label: 'Insights',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.auto_awesome),
//             label: 'AI',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.flag),
//             label: 'Goals',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';

import 'home_screen.dart';
import 'insights_screen.dart';
import 'ai_suggestion_screen.dart';
import 'goals_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // 🎨 FinCoach palette
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color barColor = Colors.black;
  static const Color accent = Color(0xFFB79CFF);

  final screens = const [
    HomeScreen(),
    InsightsScreen(),
    AiSuggestionScreen(),
    GoalsScreen(),
    ProfileScreen(),
  ];

  final items = const [
    (Icons.home, 'Home'),
    (Icons.insights, 'Insights'),
    (Icons.auto_awesome, 'Coach'),
    (Icons.flag, 'Goals'),
    (Icons.person, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseDark,
      body: screens[_currentIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == _currentIndex;
              final icon = items[index].$1;
              final label = items[index].$2;

              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent.withOpacity(0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? accent : Colors.white70,
                        size: 22,
                      ),

                      // 🔤 animated label
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        child: SizedBox(
                          width: isSelected ? null : 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}