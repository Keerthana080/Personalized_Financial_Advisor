import 'package:flutter/material.dart';
import '../services/weekly_insights_service.dart';

class WeeklyInsightsCard extends StatelessWidget {
  final WeeklyInsights insights;

  const WeeklyInsightsCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    final change = insights.percentageChange;
    final isUp = change >= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('This Week', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),

            Text(
              '₹${insights.totalSpend.toStringAsFixed(0)} spent',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isUp ? Colors.red : Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${change.abs().toStringAsFixed(1)}% vs last week',
                  style: TextStyle(color: isUp ? Colors.red : Colors.green),
                ),
              ],
            ),

            if (insights.topCategory != null) ...[
              const SizedBox(height: 8),
              Text(
                'Top category: ${insights.topCategory!.name}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
