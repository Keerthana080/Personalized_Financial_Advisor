import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';
import '../services/category_spend_service.dart';
import '../widgets/category_pie_chart.dart';

class MonthlyView extends StatelessWidget {
  const MonthlyView({super.key});

  // 🌌 Theme (same as WeeklyView)
  static const Color baseDark = Color.fromARGB(255, 32, 34, 73);
  static const Color accent = Color(0xFFB79CFF);

  static const LinearGradient finCoachGradient = LinearGradient(
    colors: [baseDark, accent],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TransactionModel>('transactions');

    return Scaffold(
      backgroundColor: baseDark,
      appBar: AppBar(
        backgroundColor: baseDark,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: ValueListenableBuilder(
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

          // 💸 Monthly debits
          final monthlyTxs = txs.where((t) {
            return t.type == TransactionType.debit &&
                t.date.month == now.month &&
                t.date.year == now.year;
          }).toList();

          final total =
              monthlyTxs.fold<double>(0, (sum, t) => sum + t.amount);

          final categoryData = CategorySpendService.calculate(monthlyTxs);
          final dailySpend = _calculateDailySpend(monthlyTxs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 💰 TOTAL (NO CARD)
                Text(
                  '₹${total.toStringAsFixed(0)} spent this month',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),

                // 📈 MONTHLY TREND
                const Text(
                  'Daily spending trend',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // 🌈 LINE CHART WITH GRADIENT BG
                Container(
                  height: 220,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: finCoachGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: dailySpend.every((e) => e == 0)
                      ? const Center(
                          child: Text(
                            'Not enough data to show trend',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            minY: 0,
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles:
                                      SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 5,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white70,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  dailySpend.length,
                                  (i) => FlSpot(
                                      (i + 1).toDouble(),
                                      dailySpend[i]),
                                ),
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.white, // ✅ WHITE LINE
                                dotData:
                                    FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                ),

                const SizedBox(height: 50),

                 Center(child: CategoryPieChart(data: categoryData)),

              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔥 Monthly daily spend logic
  List<double> _calculateDailySpend(List<TransactionModel> transactions) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final Map<int, double> dailySpend = {
      for (int i = 1; i <= daysInMonth; i++) i: 0,
    };

    for (final tx in transactions) {
      if (tx.type != TransactionType.debit) continue;
      if (tx.date.month != now.month || tx.date.year != now.year) continue;

      dailySpend[tx.date.day] =
          (dailySpend[tx.date.day] ?? 0) + tx.amount;
    }

    return List.generate(daysInMonth, (i) => dailySpend[i + 1] ?? 0);
  }
}