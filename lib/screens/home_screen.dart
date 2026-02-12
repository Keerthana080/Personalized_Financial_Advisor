import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/goals_allocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:confetti/confetti.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';
import '../models/profile_settings.dart';
import '../services/healthscore_service.dart';
import '../services/streak_service.dart';
import '../widgets/add_expense_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 🎨 COLORS (your palette)
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color accent = Color(0xFFB79CFF);

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txBox = Hive.box<TransactionModel>('transactions');
    final profileBox = Hive.box<ProfileSettings>('profile');

    final profile = profileBox.get('me')!;
    final transactions = txBox.values.toList();

    final healthScore = HealthScoreService.calculate(transactions, profile);
    final streak = StreakService.calculateWeeklyStreak(transactions);

    final spent = HealthScoreService.monthlySpent(transactions);
    final double saved =
        (profile.expectedBudget - spent).clamp(0, double.infinity);
    final totalSavings =
    (profile.expectedBudget - spent) +
    (profile.monthlyIncome - profile.expectedBudget);

final meta = Hive.box('meta');
//final today = DateTime.now().toIso8601String().substring(0, 10);
 final now = DateTime.now();
 final today = DateTime(now.year, now.month, now.day);
// if (meta.get('lastGoalAllocation') != today) {
//   GoalAllocationService.allocate(
//     income: profile.monthlyIncome,
//     expectedBudget: profile.expectedBudget,
//     spent: spent,
//   );
//   meta.put('lastGoalAllocation', today);
// }
    // 🎉 CONFETTI — ONCE PER DAY IF WITHIN BUDGET
   

    final last = profile.lastConfettiDate;
    final shownToday = last != null &&
        last.year == today.year &&
        last.month == today.month &&
        last.day == today.day;

    if (spent <= profile.expectedBudget && !shownToday) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
        profile.lastConfettiDate = today;
        profile.save();
      });
    }

    return Scaffold(
      backgroundColor: baseDark,

      // 🌈 GRADIENT APPBAR
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [baseDark, Color(0xFF3A3D8F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'FinCoach',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
            ),
          ),
        ),
      ),

      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔵 HEALTH SCORE CARD
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [baseDark, accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      CircularPercentIndicator(
  radius: 80,
  lineWidth: 12,
  percent: healthScore / 100,
  animation: true,
  circularStrokeCap: CircularStrokeCap.round,
  backgroundColor: Colors.white24,
  progressColor: _scoreColor(healthScore),
  center: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '$healthScore',
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 4), // optional spacing
      const Text(
        'Health Score',
        style: TextStyle(color: Colors.white70),
      ),
    ],
  ),
),


                      const SizedBox(height: 20),

                      // 💰 SPENT / SAVED
                      Row(
                        children: [
                          _statTile('Spent', spent, Colors.redAccent),
                          const SizedBox(width: 12),
                          _statTile('Saved', saved, Colors.greenAccent),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔥 STREAK CARD
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2E2F66), baseDark],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 32,
                    ),
                    title: Text(
                      '$streak day streak 🔥',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Within budget this week',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 🚨 OVERSPENDING ALERTS
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Overspending Alerts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _overspendingAlert(spent, profile.expectedBudget),
              ],
            ),
          ),

          // 🎊 CONFETTI WIDGET
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            emissionFrequency: 0.05,
            numberOfParticles: 30,
            gravity: 0.3,
            colors: const [
              Colors.greenAccent,
              Colors.white,
              accent,
            ],
          ),
        ],
      ),

      // ➕ FAB
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [accent, baseDark]),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (_) => const AddExpenseSheet(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Color _scoreColor(int score) {
    if (score >= 80) return Colors.greenAccent;
    if (score >= 50) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Widget _statTile(String title, double value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _overspendingAlert(double spent, double budget) {
    if (budget <= 0) {
      return const Text(
        'Set an expected budget to see alerts',
        style: TextStyle(color: Colors.white70),
      );
    }

    if (spent <= budget) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '✅ You are within your budget. Keep it up!',
          style: TextStyle(color: Colors.greenAccent),
        ),
      );
    }

    final over = spent - budget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '⚠️ You exceeded your budget by ₹${over.toStringAsFixed(0)}',
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}