import 'package:flutter/material.dart';
import 'package:flutter_application_1/init_screen.dart';
import 'package:flutter_application_1/models/category.dart';
import 'package:flutter_application_1/models/goal_model.dart';
import 'package:flutter_application_1/models/profile_settings.dart';
import 'package:flutter_application_1/models/transaction_model.dart';
import 'package:flutter_application_1/models/transaction_type.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/services/sms_sync_service.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

  // const key = String.fromEnvironment('GEMINI_KEY');
  // print('🔑 GEMINI KEY LENGTH = ${key.length}');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //   await NotificationService.init();
  // await NotificationService.show(
  //   title: 'FinCoach Ready',
  //   body: 'Notifications are working',
  // );
  // SmsSyncService.startListening();
   //await Hive.deleteFromDisk();
  Hive.registerAdapter(TransactionModelAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(ProfileSettingsAdapter());
 await Hive.openBox('meta'); // ✅ REQUIRED
  await Hive.openBox<TransactionModel>('transactions');
   await Hive.openBox<GoalModel>('goals');
  await Hive.openBox<ProfileSettings>('profile');
  final profileBox = Hive.box<ProfileSettings>('profile');
    if (!profileBox.containsKey('me')) {
    profileBox.put(
      'me',
      ProfileSettings(
        monthlyIncome: 0,
        expectedBudget: 0,
        smsSyncEnabled: true,
        notificationsEnabled: true,
      ),
    );
  }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InitScreen(), // 🔥 IMPORTANT
    );
  }
}
