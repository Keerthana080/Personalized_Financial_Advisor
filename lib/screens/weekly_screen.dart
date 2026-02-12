import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';
import '../services/weekly_insights_service.dart';
import '../services/category_spend_service.dart';
import '../widgets/weekly_insights_card.dart';
import '../widgets/overspending_card.dart';
import '../widgets/category_pie_chart.dart';
import '../widgets/add_expense_sheet.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<TransactionModel>('transactions');

    return Scaffold(
      appBar: AppBar(title: const Text('Insights'), centerTitle: true),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          final allTxs = box.values.toList();

          if (allTxs.isEmpty) {
            return const Center(child: Text('No transactions yet'));
          }

          final insights = WeeklyInsightsService.calculate(allTxs);
          final categoryData = CategorySpendService.calculate(allTxs);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                WeeklyInsightsCard(insights: insights),
                const SizedBox(height: 12),
                OverspendingCard(insights: insights),
                const SizedBox(height: 16),
                CategoryPieChart(data: categoryData),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
    );
  }
}
