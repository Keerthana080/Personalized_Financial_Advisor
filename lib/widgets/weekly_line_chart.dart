import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';

class WeeklyLineChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const WeeklyLineChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final data = _calculateDailySpend();

    if (data.every((e) => e == 0)) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        child: const Text(
          'Not enough data to show trend',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1, // 🔑 important
                getTitlesWidget: (value, meta) {
                  if (value % 1 != 0) return const SizedBox.shrink();

                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  final index = value.toInt();

                  if (index < 0 || index > 6) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      days[index],
                      style: const TextStyle(fontSize: 12),
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
              color: Theme.of(context).colorScheme.primary,
              dotData: FlDotData(show: false),
              spots: List.generate(7, (i) => FlSpot(i.toDouble(), data[i])),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 CORE LOGIC (SAFE)
  /// Builds last-7-day spend even if data is old
  List<double> _calculateDailySpend() {
    final now = DateTime.now();

    final last7Days = List.generate(
      7,
      (i) => DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: 6 - i)),
    );

    final Map<DateTime, double> dailySpend = {for (final d in last7Days) d: 0};

    for (final tx in transactions) {
      if (tx.type != TransactionType.debit) continue;

      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);

      if (dailySpend.containsKey(txDate)) {
        dailySpend[txDate] = (dailySpend[txDate] ?? 0) + tx.amount;
      }
    }

    return last7Days.map((d) => dailySpend[d] ?? 0).toList();
  }
}
