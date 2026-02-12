import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';
import '../services/category_spend_service.dart';
import '../widgets/category_pie_chart.dart';

class WeeklyView extends StatelessWidget {
  const WeeklyView({super.key});

  // 🎨 Theme
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
          final startOfWeek = DateTime(now.year, now.month, now.day)
              .subtract(Duration(days: now.weekday - 1));

          final weeklyTxs = txs.where((t) {
            return t.type == TransactionType.debit &&
                t.date.isAfter(startOfWeek);
          }).toList();

          final weeklyTotal =
              weeklyTxs.fold<double>(0, (sum, t) => sum + t.amount);

          final categoryData = CategorySpendService.calculate(weeklyTxs);
          final weeklyTrend = _calculateDailySpend(weeklyTxs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 💰 TOTAL SPENT (NO CARD)
                Text(
                  '₹${weeklyTotal.toStringAsFixed(0)} spent this week',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),

                // 📈 WEEKLY TREND
                const Text(
                  'Weekly spending trend',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // ✅ KEEP GRADIENT FOR LINE CHART
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: finCoachGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: weeklyTrend.every((e) => e == 0)
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
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    const days = [
                                      'M',
                                      'T',
                                      'W',
                                      'T',
                                      'F',
                                      'S',
                                      'S'
                                    ];
                                    final i = value.toInt();
                                    if (i < 0 || i > 6) {
                                      return const SizedBox.shrink();
                                    }
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(top: 6),
                                      child: Text(
                                        days[i],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.white,
                                dotData:
                                    FlDotData(show: false),
                                spots: List.generate(
                                  7,
                                  (i) => FlSpot(
                                      i.toDouble(),
                                      weeklyTrend[i]),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),

               
                const SizedBox(height: 50),

                // ❌ NO CONTAINER HERE
                Center(child: CategoryPieChart(data:  categoryData)),
              ],
            ),

          );
        },
      ),
    );
  }

  /// 🔥 Weekly trend logic
  List<double> _calculateDailySpend(List<TransactionModel> transactions) {
    final now = DateTime.now();

    final last7Days = List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i)),
    );

    final Map<DateTime, double> dailySpend = {
      for (final d in last7Days) d: 0
    };

    for (final tx in transactions) {
      final txDate =
          DateTime(tx.date.year, tx.date.month, tx.date.day);
      if (dailySpend.containsKey(txDate)) {
        dailySpend[txDate] =
            (dailySpend[txDate] ?? 0) + tx.amount;
      }
    }

    return last7Days.map((d) => dailySpend[d] ?? 0).toList();
  }
}