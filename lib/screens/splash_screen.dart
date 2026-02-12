import 'package:flutter/material.dart';
import 'package:flutter_application_1/init_screen.dart';
import 'dart:async';

import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/main_shell.dart';

// Import your SignInPage here if it's in a different file
// import 'sign_in_page.dart'; 

void main() => runApp(const MaterialApp(
  home: FinCoachSplashScreen(),
  debugShowCheckedModeBanner: false,
));

class FinCoachSplashScreen extends StatefulWidget {
  const FinCoachSplashScreen({super.key});

  @override
  State<FinCoachSplashScreen> createState() => _FinCoachSplashScreenState();
}

class _FinCoachSplashScreenState extends State<FinCoachSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup a smooth fade-in animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // 2. Navigation Logic (Wait 3 seconds then go to Sign In)
    Timer(const Duration(seconds: 3), () {
      // Replace 'SignInPage()' with your actual Sign In class name
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InitScreen(),),
      );
      
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Your specific color palette
    const Color bgDark = Color.fromARGB(255, 32, 34, 73);
    const Color bgLight = Color(0xFF2E2F66);
    const Color primaryAccent = Color(0xFFB79CFF);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgDark, bgLight],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryAccent.withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: primaryAccent.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 80,
                  color: primaryAccent,
                ),
              ),
              const SizedBox(height: 30),
              // App Name
              const Text(
                "FINCOACH",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(height: 10),
              // Subtitle
              Text(
                "Master Your Money",
                style: TextStyle(
                  color: primaryAccent.withOpacity(0.8),
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 80),
              // Loading Indicator in the accent color
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}