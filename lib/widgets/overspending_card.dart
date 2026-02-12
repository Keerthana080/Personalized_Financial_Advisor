import 'package:flutter/material.dart';
import '../services/weekly_insights_service.dart';

class OverspendingCard extends StatelessWidget {
  final WeeklyInsights insights;

  const OverspendingCard({super.key, required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights.previousSpend == 0 ||
        insights.totalSpend <= insights.previousSpend) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.red.shade50,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'You spent more than last week. Consider reviewing expenses.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
