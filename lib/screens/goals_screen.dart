import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_goal_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/goal_model.dart';
import '../models/profile_settings.dart';
import '../models/transaction_model.dart';
import '../models/transaction_type.dart';


class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color accent = Color(0xFFB79CFF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoAllocateSavings();
    });
  }

  void _autoAllocateSavings() {
    final goalsBox = Hive.box<GoalModel>('goals');
    final profileBox = Hive.box<ProfileSettings>('profile');
    final txBox = Hive.box<TransactionModel>('transactions');

    final profile = profileBox.get('me');
    if (profile == null) return;

    final income = profile.monthlyIncome;

    final spent = txBox.values
        .where((t) => t.type == TransactionType.debit)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final savings = max(0, income - spent);
    if (savings <= 0) return;

    final goals = goalsBox.values.toList();
    final totalPriority =
        goals.fold<double>(0, (sum, g) => sum + g.priorityPercent);

    if (totalPriority <= 0) return;

    for (final goal in goals) {
      final allocation =
          savings * (goal.priorityPercent / totalPriority);

      goal.savedAmount =
          min(allocation, goal.targetAmount);

      goal.save();
    }
  }

  void _openAddGoalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddGoalSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalsBox = Hive.box<GoalModel>('goals');

    return Scaffold(
      backgroundColor: baseDark,

      appBar: AppBar(
        backgroundColor: baseDark,
        elevation: 0,
        title: const Text(
          'Your Goals',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: accent,
        onPressed: _openAddGoalSheet,
        child: const Icon(Icons.add),
      ),

      body: ValueListenableBuilder(
        valueListenable: goalsBox.listenable(),
        builder: (context, Box<GoalModel> box, _) {
          final goals = box.values.toList();

          if (goals.isEmpty) {
            return const Center(
              child: Text(
                'No goals added yet',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              final progress =
                  (goal.savedAmount / goal.targetAmount)
                      .clamp(0.0, 1.0);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [baseDark, accent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Saved ₹${goal.savedAmount.toStringAsFixed(0)} '
                      'of ₹${goal.targetAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Priority ${goal.priorityPercent.toStringAsFixed(0)}% • '
                      '${(progress * 100).toStringAsFixed(0)}% completed',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
