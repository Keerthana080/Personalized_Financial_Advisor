import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';
import '../services/category_spend_service.dart';
import '../widgets/monthly_line_chart.dart';
import '../widgets/category_pie_chart.dart';

class MonthlyView extends StatelessWidget {
  const MonthlyView({super.key});

  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color cardDark = Color(0xFF2E2F66);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TransactionModel>('transactions');

    return Container(
      color: baseDark, // 🌙 background only
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<TransactionModel> box, __) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No transactions',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final txs = box.values.toList();
          final now = DateTime.now();

          final monthlyTxs = txs.where((t) {
            return t.type == TransactionType.debit &&
                t.date.month == now.month &&
                t.date.year == now.year;
          }).toList();

          final total =
              monthlyTxs.fold<double>(0, (sum, t) => sum + t.amount);

          final categoryData = CategorySpendService.calculate(monthlyTxs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${total.toStringAsFixed(0)} spent this month',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Daily spending trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // 📈 Monthly Line Chart card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: MonthlyLineChart(transactions: monthlyTxs),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Category breakdown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // 🥧 Pie Chart card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CategoryPieChart(data: categoryData),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}