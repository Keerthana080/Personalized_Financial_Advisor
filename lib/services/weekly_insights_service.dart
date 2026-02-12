import '../models/transaction_model.dart';
import '../models/category.dart';
import '../models/transaction_type.dart';

class WeeklyInsights {
  final double totalSpend;
  final double previousSpend;
  final Category? topCategory;

  WeeklyInsights({
    required this.totalSpend,
    required this.previousSpend,
    this.topCategory,
  });

  double get percentageChange {
    if (previousSpend == 0) return 0;
    return ((totalSpend - previousSpend) / previousSpend) * 100;
  }
}

class WeeklyInsightsService {
  static WeeklyInsights calculate(List<TransactionModel> txs) {
    final now = DateTime.now();
    final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfLastWeek = startOfThisWeek.subtract(const Duration(days: 7));

    double thisWeekTotal = 0;
    double lastWeekTotal = 0;

    final Map<Category, double> categorySpend = {};

    for (final tx in txs) {
      if (tx.type != TransactionType.debit) continue;

      if (tx.date.isAfter(startOfThisWeek)) {
        thisWeekTotal += tx.amount;
        categorySpend[tx.category] =
            (categorySpend[tx.category] ?? 0) + tx.amount;
      } else if (tx.date.isAfter(startOfLastWeek) &&
          tx.date.isBefore(startOfThisWeek)) {
        lastWeekTotal += tx.amount;
      }
    }

    Category? topCategory;
    double maxSpend = 0;

    categorySpend.forEach((cat, amt) {
      if (amt > maxSpend) {
        maxSpend = amt;
        topCategory = cat;
      }
    });

    return WeeklyInsights(
      totalSpend: thisWeekTotal,
      previousSpend: lastWeekTotal,
      topCategory: topCategory,
    );
  }
}
