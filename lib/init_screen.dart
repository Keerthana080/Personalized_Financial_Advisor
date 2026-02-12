import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import '../services/sms_sync_service.dart';
import '../screens/main_shell.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  void initState() {
    super.initState();
    _startSync();
  }

  Future<void> _startSync() async {
    await SmsSyncService.syncOnce();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing your spending…'),
          ],
        ),
      ),
    );
  }
}
