import '../models/transaction_model.dart';
import '../models/category.dart';
import '../models/transaction_type.dart';

class MonthlyInsights {
  final double totalSpend;
  final double previousMonthSpend;
  final Category? topCategory;

  MonthlyInsights({
    required this.totalSpend,
    required this.previousMonthSpend,
    this.topCategory,
  });

  double get percentageChange {
    if (previousMonthSpend == 0) return 0;
    return ((totalSpend - previousMonthSpend) / previousMonthSpend) * 100;
  }
}

class MonthlyInsightsService {
  static MonthlyInsights calculate(List<TransactionModel> txs) {
    final now = DateTime.now();

    final startOfThisMonth = DateTime(now.year, now.month, 1);
    final startOfLastMonth = DateTime(now.year, now.month - 1, 1);

    double thisMonthTotal = 0;
    double lastMonthTotal = 0;

    final Map<Category, double> categorySpend = {};

    for (final tx in txs) {
      if (tx.type != TransactionType.debit) continue;

      if (tx.date.isAfter(startOfThisMonth)) {
        thisMonthTotal += tx.amount;
        categorySpend[tx.category] =
            (categorySpend[tx.category] ?? 0) + tx.amount;
      } else if (tx.date.isAfter(startOfLastMonth) &&
          tx.date.isBefore(startOfThisMonth)) {
        lastMonthTotal += tx.amount;
      }
    }

    Category? topCategory;
    double max = 0;

    categorySpend.forEach((cat, amt) {
      if (amt > max) {
        max = amt;
        topCategory = cat;
      }
    });

    return MonthlyInsights(
      totalSpend: thisMonthTotal,
      previousMonthSpend: lastMonthTotal,
      topCategory: topCategory,
    );
  }
}
