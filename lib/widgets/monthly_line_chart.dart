import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/transaction_model.dart';
import '../models/transaction_type.dart';

class MonthlyLineChart extends StatelessWidget {
  final List<TransactionModel> transactions;

  const MonthlyLineChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final data = _calculateDailySpend();

    if (data.every((e) => e == 0)) {
      return const SizedBox(
        height: 150,
        child: Center(child: Text('Not enough data to show monthly trend')),
      );
    }

    return SizedBox(
      height: 220,
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
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                data.length,
                (i) => FlSpot(i.toDouble() + 1, data[i]),
              ),
              isCurved: true,
              barWidth: 3,
              color: Theme.of(context).colorScheme.primary,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _calculateDailySpend() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    final Map<int, double> dailySpend = {
      for (int i = 1; i <= daysInMonth; i++) i: 0,
    };

    for (final tx in transactions) {
      if (tx.type != TransactionType.debit) continue;
      if (tx.date.month != now.month || tx.date.year != now.year) continue;

      dailySpend[tx.date.day] = (dailySpend[tx.date.day] ?? 0) + tx.amount;
    }

    return List.generate(daysInMonth, (i) => dailySpend[i + 1] ?? 0);
  }
}
