import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_goal_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/goal_model.dart';
import '../models/profile_settings.dart';
import '../models/transaction_model.dart';
import '../models/transaction_type.dart';


class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  // 🎨 FinCoach palette
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color accent = Color(0xFFB79CFF);

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF6D5DF6), Color(0xFF9B7BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final goalsBox = Hive.box<GoalModel>('goals');
    final txBox = Hive.box<TransactionModel>('transactions');
    final profileBox = Hive.box<ProfileSettings>('profile');

    final profile = profileBox.get('me')!;

    // 💸 TOTAL SPENT
    final spent = txBox.values
        .where((t) => t.type == TransactionType.debit)
        .fold<double>(0, (sum, t) => sum + t.amount);

    // 💰 TOTAL SAVINGS
    final totalSavings = max(0.0, profile.monthlyIncome - spent);

    return Scaffold(
      backgroundColor: baseDark,

      appBar: AppBar(
        backgroundColor: baseDark,
        elevation: 0,
        title: const Text(
          'Your Goals',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => const AddGoalSheet(),
              );
            },
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: goalsBox.listenable(),
        builder: (context, Box<GoalModel> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No goals yet. Tap + to add one.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final goals = box.values.toList();

          // 🔑 EVEN SPLIT
          final evenShare = totalSavings / goals.length;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];

              // ✅ CORE FIX (THIS WAS MISSING BEFORE)
              final allocated =
                  min(evenShare, goal.targetAmount);

              if (goal.savedAmount != allocated) {
                goal.savedAmount = allocated;
                goal.save();
              }

              final progress =
                  (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: cardGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🎯 TITLE
                    Text(
                      goal.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 📊 PROGRESS BAR (NOW MOVES)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 💰 DETAILS
                    Text(
                      'Saved ₹${goal.savedAmount.toStringAsFixed(0)} '
                      'of ₹${goal.targetAmount.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% completed',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
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