import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';

import '../services/sms_sync_service.dart';
import 'main_navigation.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final Telephony telephony = Telephony.instance;
  bool loading = false;

  Future<void> _requestPermission() async {
    setState(() => loading = true);

    final granted = await telephony.requestPhoneAndSmsPermissions;

    if (granted == true) {
      await SmsSyncService.syncOnce();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('SMS permission required')));
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: loading ? null : _requestPermission,
          child: loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Allow SMS Permission'),
        ),
      ),
    );
  }
}
